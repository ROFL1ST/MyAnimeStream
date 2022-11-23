// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/API/model/recent_anime.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/continueManager.dart';
import 'package:my_anime_stream/helpers/historyManager.dart';
import 'package:my_anime_stream/pages/episode/webview_screen.dart';
import 'package:my_anime_stream/pages/home/components/cache_image_with_cachemanager.dart';

class Continue extends StatefulWidget {
  const Continue({super.key});

  @override
  State<Continue> createState() => _ContinueState();
}

class _ContinueState extends State<Continue> {
  final HistoryManager historyManager = Get.put(HistoryManager());
  final ContinueManager continueManager = Get.put(ContinueManager());

  @override
  void initState() {
    historyManager.loadHistoryFromDatabase();
    continueManager.loadContinueFromDatabase();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<void>(
      future: continueManager.loadContinueFromDatabase(),
      builder: (context, AsyncSnapshot snapshot) => GetBuilder<HistoryManager>(
        builder: (_) => continueManager.continueList.isNotEmpty
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Continue Watching",
                        style: kTitleTextStyle,
                      ),
                      // IconButton(
                      //   onPressed: () {

                      //   },
                      //   icon: Icon(Iconsax.arrow_circle_right),
                      // )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.01),
                    height: size.height * 0.2,
                    width: size.width,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: continueManager.continueList.length,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: size.height * 0.26,
                          mainAxisSpacing: 25),
                      itemBuilder: (context, index) {
                        return card(
                            continueManager.continueList[index], size, index);
                      },
                    ),
                  ),
                ],
              )
            : SizedBox(),
      ),
    );
  }

  Widget card(data, size, index) {
    return InkWell(
        onTap: () async {
          DateTime now = DateTime.now();
          final history = RecentAnime(
            id: data.id,
            episodeId: data.episodeId,
            currentEp: data.currentEp,
            epUrl: data.epUrl,
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
          // log("${history.image}");
          await Get.to(
            WebViewScreen(
              slug: data.episodeId,
              detail: ApiService().detail(data.id),
              currentIndex: int.parse(data.currentEp),
              prevPage: "Home",
            ),
          );
          // arah ke episode yg dituju
        },
        child: Container(
          // height: size.w * 0.02,
          decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.159,
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
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     Expanded(
                            //       child: Container(
                            //         width: size.width,
                            //         // height: (size.height) - 721,
                            //         decoration: BoxDecoration(
                            //           color: Colors.black.withOpacity(0.5),
                            //           borderRadius: BorderRadius.circular(10),
                            //         ),
                            //         child: Icon(Icons.play_arrow),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     Container(
                            //       width: size.width / 4,
                            //       height: 6,
                            //       decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         borderRadius: BorderRadius.all(
                            //           Radius.circular(2),
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 10, right: 10,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.3,
                        child: AutoSizeText(
                          "Episode ${int.parse(data.currentEp) + 1}",
                          minFontSize: 5,
                          maxLines: 1,
                          style: kTitleTextStyle.copyWith(fontSize: 14),
                        ),
                      ),
                      //  SizedBox(
                      //   width: size.width * 0.2,
                      //   child: AutoSizeText(
                      //     data.title,
                      //     minFontSize: 14,
                      //     maxLines: 1,
                      //     style: kTitleTextStyle.copyWith(fontSize: 14),
                      //   ),
                      // ),
                      Icon(Icons.play_arrow)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
