// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_const, curly_braces_in_flow_control_structures

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/API/model/recent_anime.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';
import 'package:my_anime_stream/helpers/historyManager.dart';
import 'package:my_anime_stream/pages/detail/component/characters.dart';
import 'package:my_anime_stream/pages/detail/component/isi.dart';
import 'package:my_anime_stream/pages/detail/component/listEpisode.dart';
import 'package:my_anime_stream/pages/detail/component/title.dart';
import 'package:my_anime_stream/pages/episode/webview_screen.dart';
import 'package:html/parser.dart';

class Detail extends StatefulWidget {
  final images;
  final slug;
  final type;
  const Detail(
      {super.key,
      required this.images,
      required this.slug,
      required this.type});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final HistoryManager historyManager = Get.put(HistoryManager());

  late Future detail;
  bool isOpen = false;
  bool showbtn = true;
  void refresh() {
    setState(() {
      detail = ApiService().detail(widget.slug);
    });
  }

  @override
  void initState() {
    super.initState();
    detail = ApiService().detail(widget.slug);
    historyManager.loadHistoryFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bg,
      body: RefreshIndicator(
        onRefresh: () async {
          refresh();
        },
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Hero(
                tag: widget.slug,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        widget.images,
                        cacheManager: CustomCacheManager.instance,
                      ),
                    ),
                  ),
                  height: size.height * 0.5,
                ),
              ),
              Container(
                height: size.height * 0.501,
                decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.transparent,
                      bg,
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CupertinoButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: size.width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              (widget.type == "MOVIE")
                  ? GetBuilder<HistoryManager>(
                      builder: (_) => FutureBuilder(
                          future: detail,
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) return Text("");
                            if (snapshot.hasError) return Text("");
                            if (snapshot.hasData) {
                              var episode = snapshot.data.episodes[0];
                              return Center(
                                child: Container(
                                  height: size.height * 0.07,
                                  width: size.width * 0.15,
                                  margin: EdgeInsets.only(
                                    top: size.height * 0.2,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(250)),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.play_arrow_rounded,
                                      size: size.width * 0.075,
                                    ),
                                    onPressed: () async {
                                      DateTime now = DateTime.now();

                                      final history = RecentAnime(
                                        id: snapshot.data.id,
                                        episodeId: episode.id,
                                        currentEp:
                                            (episode.number - 1).toString(),
                                        title: snapshot.data.title.romaji,
                                        image: snapshot.data.image,
                                        createAt: now.toString(),
                                        type: snapshot.data.type,
                                        imageEps: episode.image,
                                      );
                                      // log("${history.currentEp}");
                                      if (historyManager.epsIdList
                                          .contains(episode.id)) {
                                        historyManager
                                            .removeHistory(episode.id);
                                        historyManager.addHistoryAnime(history);
                                      } else {
                                        historyManager.addHistoryAnime(history);
                                      }
                                      await Get.to(
                                        WebViewScreen(
                                          detail: detail,
                                          slug: episode.id,
                                          currentIndex:
                                              (episode.number - 1).toString(),
                                          prevPage: "Detail",
                                          image: episode.image,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Text("");
                            }
                          }))
                  : SizedBox(),
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.4, left: 15, right: 15, bottom: 20),
                child: Column(
                  children: [
                    Top(
                      detail: detail,
                      size: size,
                    ),
                    SizedBox(
                      height: size.height * 0.023,
                    ),

                    CharactersBuilder(
                      detail: detail,
                    ),
                    Isi(
                      detail: detail,
                      size: size,
                    ),
                    SizedBox(
                      height: size.height * 0.023,
                    ),
                    (widget.type != "MOVIE")
                        ? ListEpisode(detail: detail)
                        : SizedBox(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Related Anime",
                                      style: kTitleDetailStyle,
                                    )
                                  ],
                                ),
                                FutureBuilder(
                                  future: detail,
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done)
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          // bottom: 6,

                                          top: 18,
                                        ),
                                        child: SizedBox(
                                          height: size.height * 0.24,
                                          width: size.width,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 10,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    // bottom: 6,

                                                    right: 18,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height:
                                                            size.height * 0.13,
                                                        width:
                                                            size.width * 0.34,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: cardBg,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.01,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                      );
                                    if (snapshot.hasError) return Text("Error");
                                    if (snapshot.hasData) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          // bottom: 6,

                                          top: 18,
                                        ),
                                        child: SizedBox(
                                          height: size.height * 0.24,
                                          width: size.width,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot
                                                  .data.relations.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    // bottom: 6,

                                                    right: 18,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height:
                                                            size.height * 0.13,
                                                        width:
                                                            size.width * 0.34,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                                  image:
                                                                      CachedNetworkImageProvider(
                                                                    snapshot
                                                                        .data
                                                                        .relations[
                                                                            index]
                                                                        .image,
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.01,
                                                      ),
                                                      SizedBox(
                                                        width: size.width * 0.3,
                                                        child: AutoSizeText(
                                                          snapshot
                                                                  .data
                                                                  .relations[
                                                                      index]
                                                                  .title
                                                                  .romaji ??
                                                              "",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                      );
                                    } else {
                                      return Text("Kosong");
                                    }
                                  },
                                ),
                              ],
                            ),
                          )

                    // Container(
                    //   decoration: const BoxDecoration(
                    //     color: Colors.white,
                    //     gradient: const LinearGradient(
                    //       colors: [
                    //         Colors.black, //define your gradient color here
                    //         Colors.grey,
                    //       ],
                    //     ),
                    //   ),
                    //   child: ClipRRect(
                    //     borderRadius: const BorderRadius.only(
                    //       topLeft: Radius.circular(25.0),
                    //       topRight: Radius.circular(25.0),
                    //     ),
                    //     child: ElevatedButton(
                    //       onPressed: () {},
                    //       child: Text("D"),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
