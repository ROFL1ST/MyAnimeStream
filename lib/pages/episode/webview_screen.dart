// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/API/model/favorite.dart';
import 'package:my_anime_stream/API/model/recent_anime.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';
import 'package:my_anime_stream/helpers/favoriteManager.dart';
import 'package:my_anime_stream/helpers/historyManager.dart';
import 'package:my_anime_stream/pages/detail/component/isi.dart';
import 'package:my_anime_stream/pages/detail/detail.dart';
import 'package:my_anime_stream/pages/episode/component/player.dart';

import 'package:my_anime_stream/pages/episode/component/title.dart';

import '../../helpers/tako_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/tako_play_web_view.dart';

class WebViewScreen extends StatefulWidget {
  final mediaUrl;
  final slug;
  final detail;
  final currentIndex;
  final prevPage;
  final image;
  const WebViewScreen(
      {Key? key,
      this.mediaUrl,
      required this.slug,
      required this.detail,
      required this.currentIndex,
      required this.prevPage,
      required this.image})
      : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  var isLandScape = true.obs;
  final GlobalKey webViewKey = GlobalKey();
  late Future top;
  late Future url;
  late Future eps;
  final HistoryManager historyManager = Get.put(HistoryManager());

  int index = 0;
  ScrollController? _scrollController;
  final floating = Floating();

  @override
  void initState() {
    index = int.parse(widget.currentIndex);
    top = ApiService().top();
    eps = ApiService().episode(widget.slug);
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    if (Platform.isIOS) WebView.platform = CupertinoWebView();
    historyManager.loadHistoryFromDatabase();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void next() {
    setState(() {
      index = index + 1;
    });
  }

  void prev() {
    setState(() {
      index = index - 1;
    });
  }

  void updatePage(data) {
    // log("${widget.allEps[id].id}");
    eps = ApiService().episode(data[index].id);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _scrollController?.dispose();
    floating.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.inactive) {
      floating.enable(Rational.square());
    }
  }

  Future<void> enablePip() async {
    final status = await floating.enable(Rational.landscape());
    debugPrint('PiP enabled? $status');
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // takoDebugPrint(Get.arguments['mediaUrl'].toString());
    // log("${widget.mediaUrl}");
    return WillPopScope(
      onWillPop: () async {
        if (!isLandScape.value) {
          return true;
        } else {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);

          return false;
        }
      },
      child: Scaffold(
        backgroundColor: bg,
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            isLandScape.value = true;
            SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.immersiveSticky,
            );
          } else {
            isLandScape.value = false;
            SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: [
                SystemUiOverlay.top,
                SystemUiOverlay.bottom,
              ],
            );
          }
          return SafeArea(
            child: Column(
              children: [
                FutureBuilder(
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState != ConnectionState.done)
                      return loadingPlayer(size, widget.image);
                    if (snapshot.hasError) return Text("Error");
                    if (snapshot.hasData)
                      return (snapshot.data == "message")
                          ? Center(
                              child: Text("Down"),
                            )
                          : videoPlayer(
                              snapshot.data?.headers.referer, orientation);
                    return Text("Kosong");
                  },
                  future: eps,
                ),
                // FutureBuilder(
                //     future: eps,
                //     builder: (context, AsyncSnapshot snapshot) {
                //       if (snapshot.connectionState != ConnectionState.done)
                //         return loadingPlayer(size);
                //       if (snapshot.hasError) return Text("Error");
                //       if (snapshot.hasData) {
                //         log("${snapshot.data.sources[4].quality}");
                //         return Player(url: snapshot.data.sources[4].url, orientation: orientation,);
                //       } else {
                //         return Text("");
                //       }
                //     }),
                orientation != Orientation.landscape
                    ? Container(
                        height: Get.height * 0.62,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 15, right: 15, top: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Top(
                                      detail: widget.detail,
                                      size: size,
                                      episode: index + 1),
                                  SizedBox(
                                    height: size.height * 0.023,
                                  ),
                                  Isi(
                                    detail: widget.detail,
                                    size: size,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.023,
                                  ),
                                  FutureBuilder(
                                      future: widget.detail,
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done)
                                          return loadNextPrev(size);
                                        if (snapshot.hasError)
                                          return Center(
                                              child: Column(
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text("No Connection"),
                                            ],
                                          ));
                                        if (snapshot.hasData) {
                                          return nextPrev(size, snapshot.data);
                                        } else {
                                          return Text("");
                                        }
                                      }),
                                  SizedBox(
                                    height: size.height * 0.033,
                                  ),
                                  Text(
                                    "Top",
                                    style: kTitleTextStyle,
                                  ),
                                  FutureBuilder(
                                    future: top,
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState !=
                                          ConnectionState.done)
                                        return listLoading(size);
                                      if (snapshot.hasError)
                                        return Text("Error");
                                      if (snapshot.hasData)
                                        return listBuilder(snapshot.data, size);
                                      return Text("Kosong");
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget loadNextPrev(size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: cardBg.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.skip_previous,
                  color: Colors.white.withOpacity(0.4),
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Text(
                  "Previous",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.list,
                  color: Colors.white.withOpacity(0.4),
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Text(
                  "Episode",
                  style: TextStyle(color: Colors.white.withOpacity(0.4)),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
            child: Row(
              children: [
                Text(
                  "Next",
                  style: TextStyle(color: Colors.white.withOpacity(0.4)),
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Icon(
                  Icons.skip_next,
                  color: Colors.white.withOpacity(
                    0.4,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget nextPrev(size, data) {
    return GetBuilder<HistoryManager>(
        builder: (_) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (index == 0)
                    ? Container(
                        decoration: BoxDecoration(
                          color: cardBg.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.skip_previous,
                                color: Colors.white.withOpacity(0.4),
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Text(
                                "Previous",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          prev();
                          updatePage(data.episodes);

                          DateTime now = DateTime.now();

                          final history = RecentAnime(
                            id: data.id,
                            episodeId: data.episodes[index].id,
                            currentEp:
                                (data.episodes[index].number - 1).toString(),
                            title: data.title.romaji,
                            image: data.image,
                            createAt: now.toString(),
                            type: data.type,
                            imageEps: data.episodes[index].image,
                          );
                          if (historyManager.epsIdList
                              .contains(data.episodes[index].id)) {
                            historyManager
                                .removeHistory(data.episodes[index].id);
                            historyManager.addHistoryAnime(history);
                          } else {
                            historyManager.addHistoryAnime(history);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.skip_previous),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Text("Previous")
                              ],
                            ),
                          ),
                        ),
                      ),
                InkWell(
                  onTap: () {
                    if (widget.prevPage != "Home") {
                      Get.back();
                    } else {
                      Get.off(Detail(
                        images: data.image,
                        slug: data.id,
                        type: data.type,
                      ));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.list),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          Text("Episode"),
                        ],
                      ),
                    ),
                  ),
                ),
                (index + 1 == data.episodes.length)
                    ? Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                          child: Row(
                            children: [
                              Text(
                                "Next",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.4)),
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Icon(
                                Icons.skip_next,
                                color: Colors.white.withOpacity(
                                  0.4,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          next();
                          updatePage(data.episodes);

                          DateTime now = DateTime.now();

                          final history = RecentAnime(
                            id: data.id,
                            episodeId: data.episodes[index].id,
                            currentEp:
                                (data.episodes[index].number - 1).toString(),
                            title: data.title.romaji,
                            image: data.image,
                            createAt: now.toString(),
                            type: data.type,
                            imageEps: data.episodes[index].image,
                          );
                          if (historyManager.epsIdList
                              .contains(data.episodes[index].id)) {
                            historyManager
                                .removeHistory(data.episodes[index].id);
                            historyManager.addHistoryAnime(history);
                          } else {
                            historyManager.addHistoryAnime(history);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                            child: Row(
                              children: [
                                Text("Next"),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Icon(Icons.skip_next),
                              ],
                            ),
                          ),
                        ),
                      )
              ],
            ));
  }

  Widget videoPlayer(data, orientation) {
    return AspectRatio(
      aspectRatio: orientation == Orientation.landscape ? 19.5 / 9 : 4 / 2.885,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.fromSize(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            child: TakoPlayWebView(
              initialUrl: data,
              onLoadingFinished: (_webViewController) async {
                try {
                  //
                  for (var i = 0; i < 10; i++) {
                    await _webViewController.runJavascriptReturningResult(
                        "document.getElementsByTagName('iframe')[$i].style.display='none';");
                    await _webViewController.runJavascriptReturningResult(
                        "document.getElementsByClassName('jw-icon jw-icon-display jw-button-color jw-reset')[0].click();");
                  }
                  //
                  for (var i = 0; i < 8; i++) {
                    await _webViewController.runJavascriptReturningResult(
                        "document.getElementsByTagName('iframe')[$i].style.display='none';");
                  }
                  await _webViewController.runJavascriptReturningResult(
                      "document.getElementsByClassName('jw-icon jw-icon-inline jw-button-color jw-reset jw-icon-fullscreen')[1].click();");
                  await _webViewController.runJavascriptReturningResult(
                      "if(document.getElementsByClassName('jw-icon jw-icon-display jw-button-color jw-reset')[0].ariaLabel == 'Play'){document.getElementsByClassName('jw-icon jw-icon-display jw-button-color jw-reset')[0].click();}");
                  //
                  for (var i = 0; i < 8; i++) {
                    await _webViewController.runJavascriptReturningResult(
                        "document.getElementsByTagName('iframe')[$i].style.display='none';");
                  }
                  // await Future.delayed(const Duration(seconds: 1), () {

                  // });
                  for (var i = 0; i < 10; i++) {
                    await _webViewController.runJavascriptReturningResult(
                        "document.getElementsByTagName('iframe')[$i].style.display='none';");
                  }
                  setState(() {});
                } catch (e) {
                  print('An error occurred while parsing data from webView:');
                  print(e.toString());
                  rethrow;
                }
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 10,
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      if (isLandScape.value) {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                        ]);
                      } else {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeRight,
                          DeviceOrientation.landscapeLeft,
                        ]);
                      }
                    },
                    icon: const Icon(
                      Icons.zoom_out_map_outlined,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingPlayer(size, image) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: CachedNetworkImageProvider(
              image,
              cacheManager: CustomCacheManager.instance,
            ),
            fit: BoxFit.cover,
            opacity: 0.3),
      ),
      height: size.height * 0.3,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget listBuilder(data, size) {
    // var top = data.where((e) => e.results);
    return Column(
        children: data.results.map<Widget>((e) {
      return card(e, size);
    }).toList());
  }

  Widget listLoading(size) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          cardLoading(size),
          cardLoading(size),
          cardLoading(size),
        ],
      ),
    );
  }

  Widget cardLoading(size) {
    return Container(
      width: size.width,
      height: size.height * 0.12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: size.height * 0.1,
                    width: size.width * 0.2,
                    decoration: BoxDecoration(color: cardBg),
                  )),
              SizedBox(
                width: size.width * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.5,
                      height: size.height * 0.02,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: cardBg,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      width: size.width * 0.3,
                      height: size.height * 0.02,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: cardBg,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_outline),
          )
        ],
      ),
    );
  }

  Widget card(data, size) {
    final FavoriteManager favoriteManager = Get.put(FavoriteManager());

    print(widget.slug != data.id);
    if (widget.slug != data.id) {
      return InkWell(
        onTap: () {
          Get.off(Detail(
            images: data.image,
            slug: data.id,
            type: data.type,
          ));
        },
        child: Container(
          width: size.width,
          height: size.height * 0.12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      data.image,
                      height: size.height * 0.1,
                      width: size.width * 0.2,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.5,
                          child: AutoSizeText(
                            data.title.romaji,
                            style: kListTitleStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Container(
                          width: size.width * 0.5,
                          child: AutoSizeText(
                            data.genres.join(", "),
                            style: kListSubtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              GetBuilder<FavoriteManager>(
                builder: (_) => IconButton(
                  onPressed: () {
                    final item = Favorite(
                      id: data.id,
                      title: data.title,
                      type: data.type,
                      image: data.image,
                      genre: data.genres.join(", "),
                    );
                    if (favoriteManager.ids.contains(data.id.toString())) {
                      favoriteManager.removeFromFavorite(item);
                      Get.snackbar(
                        data.title,
                        "Ahh,${data.title} Removed From Favorite 😨",
                        backgroundColor: Colors.black38,
                        duration: const Duration(milliseconds: 1300),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      favoriteManager.addToFavorite(item);
                      Get.snackbar(data.title,
                          'Yeay!!, ${data.title} Added to bookmark successfully! 😊',
                          backgroundColor: Colors.black38,
                          duration: const Duration(milliseconds: 1300),
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  icon: Icon(favoriteManager.ids.contains(data.id)
                      ? Icons.favorite
                      : Icons.favorite_outline),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
