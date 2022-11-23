import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/API/model/recent_anime.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';
import 'package:my_anime_stream/helpers/historyManager.dart';
import 'package:my_anime_stream/pages/detail/detail.dart';
import 'package:my_anime_stream/pages/episode/webview_screen.dart';
import 'package:my_anime_stream/pages/home/components/cache_image_with_cachemanager.dart';
import 'package:my_anime_stream/pages/recent/recentPages.dart';

class Recent extends StatefulWidget {
  final size;
  final recent;
  final refreshRecent;
  const Recent(
      {super.key,
      required this.size,
      required this.recent,
      required this.refreshRecent});

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  final HistoryManager historyManager = Get.put(HistoryManager());

  @override
  void initState() {
    historyManager.loadHistoryFromDatabase();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Updates",
              style: kTitleTextStyle,
            ),
            IconButton(
              onPressed: () {
                Get.to(RecentPages(), arguments: widget.recent);
              },
              icon: Icon(Iconsax.arrow_circle_right),
            )
          ],
        ),
        FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return listLoading(widget.size);
            if (snapshot.hasError) return error(widget.size);
            if (snapshot.hasData)
              return listBuilder(snapshot.data.results, widget.size);
            return Text("Kosong");
          },
          future: widget.recent,
        )
      ],
    );
  }

  Widget listBuilder(data, size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      height: size.height * 0.25,
      width: size.width,
      child: GridView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: data.length,
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: size.height * 0.16,
              mainAxisSpacing: 25),
          itemBuilder: (context, index) {
            return card(data[index], size);
          }),
    );
  }

  Widget card(data, size) {
    return GetBuilder<HistoryManager>(
      builder: (_) => InkWell(
        onTap: () async {
          DateTime now = DateTime.now();

          final history = RecentAnime(
            id: data.id,
            episodeId: data.episodeId,
            currentEp: (data.episodeNumber - 1).toString(),
            epUrl: data.url,
            title: data.title,
            image: data.image,
            createAt: now.toString(),
          );
          if (historyManager.epsIdList.contains(data.episodeId)) {
            historyManager.removeHistory(data.episodeId);
            historyManager.addHistoryAnime(history);
          } else {
            historyManager.addHistoryAnime(history);
          }
          // log("${history.createAt}");
          await Get.to(
            WebViewScreen(
              slug: data.episodeId,
              detail: ApiService().detail(data.id),
              currentIndex: data.episodeNumber - 1,
              prevPage: "Home",
            ),
          );
          // arah ke episode yg dituju
        },
        child: Container(
          height: size.height * 0.04,
          decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.214,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: NetworkImageWithCacheManager(
                                imageUrl: data.image,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    width: size.width,
                    child: Center(
                      child: AutoSizeText(
                        "Episode ${data.episodeNumber.toString()}",
                        minFontSize: 5,
                        maxLines: 1,
                        style: kTitleTextStyle.copyWith(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listLoading(size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      height: size.height * 0.27,
      width: size.width,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: size.height * 0.16,
            mainAxisSpacing: 30),
        itemBuilder: (context, index) {
          return cardLoading(size);
        },
      ),
    );
  }

  Widget cardLoading(size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cardBg,
      ),
    );
  }

  Widget error(size) {
    return Center(
      child: Container(
        height: size.height * 0.27,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No Connection"),
            ElevatedButton(
              onPressed: widget.refreshRecent,
              child: Text("Retry"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kFavIconColor)),
            )
          ],
        ),
      ),
    );
  }
}
