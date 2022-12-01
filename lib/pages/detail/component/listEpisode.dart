// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/API/model/detail.dart';
import 'package:my_anime_stream/API/model/recent_anime.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';
import 'package:my_anime_stream/helpers/historyManager.dart';
import 'package:my_anime_stream/pages/episode/webview_screen.dart';

class ListEpisode extends StatefulWidget {
  final detail;
  const ListEpisode({super.key, required this.detail});

  @override
  State<ListEpisode> createState() => _ListEpisodeState();
}

class _ListEpisodeState extends State<ListEpisode> {
  final HistoryManager historyManager = Get.put(HistoryManager());
  bool hasRemainingEp = false;
  int remainingEp = 0;
  int totalChipCount = 0;
  RxList<Episode> epChunkList = <Episode>[].obs;
  String start = '';
  String end = '';
  var selectedIndex = 9999999.obs;
  int finalChipCount = 0;

  var selectedChipIndex = 0.obs;
  @override
  void initState() {
    // TODO: implement initState
    historyManager.loadHistoryFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return loading(size);
        if (snapshot.hasError) return Text("Error");
        if (snapshot.hasData) {
          if ((snapshot.data!.episodes!.length % 30).floor() < 30) {
            hasRemainingEp = true;
            remainingEp = (snapshot.data.episodes!.length % 30).floor();
          }
          totalChipCount = (snapshot.data.episodes!.length / 30).floor();
          epChunkList.value = snapshot.data.episodes!.sublist(
              0,
              (hasRemainingEp == true && snapshot.data.episodes!.length < 30)
                  ? remainingEp
                  : 30);
          finalChipCount = totalChipCount + (hasRemainingEp ? 1 : 0);
          print('Ep Chunk List ${epChunkList.length}+ $remainingEp');
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: const Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    "Episodes",
                    style: kTitleTextStyle,
                  ),
                  Text(
                    "Total : ${snapshot.data.totalEpisodes}",
                    style: kSubtitleTextStyle,
                  ),
                ],
              ),
              // Column(
              //   children: data.episodes
              //       .asMap()
              //       .entries
              //       .map<Widget>(
              //           (e) => episodeCard(e.value, size, e.key, data.episodes, data))
              //       .toList(),
              // )
              snapshot.data.episodes.length > 30
                  ? SizedBox(
                      height: size.height * 0.09,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: finalChipCount,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                // bottom: 6,
                                left: 8,
                                right: 8,
                              ),
                              child: InkWell(
                                onTap: () {
                                  // log("message");
                                  selectedChipIndex.value = index;
                                  selectedIndex.value = 99999999;
                                  getEpisodeRange(index);

                                  if (finalChipCount == (index + 1)) {
                                    epChunkList.value =
                                        snapshot.data.episodes!.sublist(
                                      int.parse(start) - 1,
                                    );
                                  } else {
                                    epChunkList.value = snapshot.data.episodes
                                        .sublist(int.parse(start) - 1,
                                            int.parse(end));
                                  }
                                  log("${epChunkList}");
                                },
                                child: Obx(
                                  () => Chip(
                                    backgroundColor:
                                        selectedChipIndex.value == index
                                            ? cardBg
                                            : Color.fromARGB(305, 19, 18, 18)
                                                .withOpacity(.8),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    label: Text(getEpisodeRange(index),
                                        style: kSubtitleDetailStyle),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : SizedBox(),
              snapshot.data.episodes.isNotEmpty
                  ? Obx(() => SizedBox(
                        height: epChunkList.length < 12
                            ? size.height * 1.3
                            : epChunkList.length * 98,
                        child: ListView.builder(
                          itemCount: epChunkList.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GetBuilder<HistoryManager>(
                                  builder: (_) => InkWell(
                                        onTap: () async {
                                          DateTime now = DateTime.now();

                                          final history = RecentAnime(
                                            id: snapshot.data.id,
                                            episodeId: epChunkList[index].id,
                                            currentEp:
                                                (epChunkList[index].number - 1)
                                                    .toString(),
                                            title: snapshot.data.title.romaji,
                                            image: snapshot.data.image,
                                            createAt: now.toString(),
                                            type: snapshot.data.type, imageEps: epChunkList[index].image,
                                          );
                                          // log("${history.currentEp}");
                                          if (historyManager.epsIdList.contains(
                                              epChunkList[index].id)) {
                                            historyManager.removeHistory(
                                                epChunkList[index].id);
                                            historyManager
                                                .addHistoryAnime(history);
                                          } else {
                                            historyManager
                                                .addHistoryAnime(history);
                                          }
                                          await Get.to(
                                            WebViewScreen(
                                              detail: widget.detail,
                                              slug: epChunkList[index].id,
                                              currentIndex:
                                                  (epChunkList[index].number -
                                                          1)
                                                      .toString(),
                                              prevPage: "Detail",
                                              image: epChunkList[index].image,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: historyManager.epsIdList
                                                    .contains(
                                                        epChunkList[index].id)
                                                ? cardBg.withOpacity(0.03)
                                                : cardBg,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          epChunkList[index]
                                                              .image,
                                                      key: UniqueKey(),
                                                      cacheManager:
                                                          CustomCacheManager
                                                              .instance,
                                                      height: size.height * 0.1,
                                                      width: size.width * 0.3,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.01,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10.0,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.45,
                                                          child: AutoSizeText(
                                                            epChunkList[index]
                                                                    .title ??
                                                                "",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            minFontSize: 14,
                                                            style: historyManager
                                                                    .epsIdList
                                                                    .contains(
                                                                        epChunkList[index]
                                                                            .id)
                                                                ? kListTitleStyle
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .grey)
                                                                : kListTitleStyle,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: size.height *
                                                              0.005,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.4,
                                                          child: AutoSizeText(
                                                            epChunkList[index]
                                                                    .description ??
                                                                "",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            minFontSize: 14,
                                                            style:
                                                                kListSubtitle,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0),
                                                child: Center(
                                                  child: Text(
                                                    epChunkList[index]
                                                        .number
                                                        .toString(),
                                                    style: kSubtitleDetailStyle,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                            );
                          },
                        ),
                      ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Coming Soon ..',
                        style: kSubtitleDetailStyle,
                      ),
                    ),
            ],
          );
        } else {
          return Text("Kosong");
        }
      },
      future: widget.detail,
    );
  }

  Widget loading(size) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: const Divider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text(
              "Episodes",
              style: kTitleTextStyle,
            ),
            Text(
              "Total : Loading...",
              style: kSubtitleTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.2,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              maxCrossAxisExtent: 50,
            ),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            // scrollDirection: Axis.horizontal,
            itemCount: 12,
            itemBuilder: (context, index) {
              // return episodeCard(epChunkList[index], size, index,
              //     snapshot.data.episodes, snapshot.data);

              return episodeLoading(size);
            },
          ),
        ),
      ],
    );
  }

  Widget episodeLoading(size) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cardBg,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
        ),
      ),
    );
  }

  String getEpisodeRange(int index) {
    start = ((index * 30) + 1).toString();
    end = ((30 * (index + 1))).toString();
    if (index == totalChipCount && hasRemainingEp) {
      end = ((30 * index) + remainingEp).toString();
    }
    // startVal = start;
    // endVal = (int.parse(end) + 1).toString();
    return ('$start - $end');
  }
}
