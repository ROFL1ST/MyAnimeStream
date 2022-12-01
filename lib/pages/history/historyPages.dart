// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/API/model/recent_anime.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/continueManager.dart';
import 'package:my_anime_stream/helpers/historyManager.dart';
import 'package:my_anime_stream/pages/episode/webview_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistoryPages extends StatefulWidget {
  final detail;
  const HistoryPages({super.key, required this.detail});

  @override
  State<HistoryPages> createState() => _HistoryPagesState();
}

class _HistoryPagesState extends State<HistoryPages> {
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

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text(
          "History",
          style: kTitleDetailStyle,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: FutureBuilder<void>(
        future: historyManager.loadHistoryFromDatabase(),
        builder: (context, AsyncSnapshot snapshot) =>
            GetBuilder<HistoryManager>(
          builder: (_) => Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: historyManager.animeList.length,
                itemBuilder: (context, index) {
                  return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        // ignore: sort_child_properties_last
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              historyManager.removeHistory(
                                historyManager.animeList[index].id,
                              );
                             
                            },
                            label: 'Delete',
                            icon: Icons.delete,
                            foregroundColor: Colors.redAccent,
                            backgroundColor: cardBg,
                          ),
                        ],
                        dismissible: DismissiblePane(
                          onDismissed: () {
                            historyManager.removeHistory(
                              historyManager.animeList[index].episodeId,
                            );
                            
                          },
                        ),
                      ),
                      key: UniqueKey(),
                      child:
                          card(historyManager.animeList[index], size, index));
                }),
          ),
        ),
      )),
    );
  }

  Widget card(data, size, index) {
    return Container(
      width: size.width,
      height: size.height * 0.12,
      child: Row(
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
                    SizedBox(
                      width: size.width * 0.55,
                      child: AutoSizeText(
                        data.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 16,
                        style: kListTitleStyle,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.005,
                    ),
                    SizedBox(
                      width: size.width * 0.55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            "Episode ${(int.parse(data.currentEp) + 1).toString()}",
                            maxLines: 1,
                            style: kListSubtitle,
                            minFontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AutoSizeText(
                            "${timeago.format(DateTime.parse(data.createAt))}",
                            maxLines: 1,
                            style: kListSubtitle,
                            minFontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          IconButton(
            onPressed: () async {
              DateTime now = DateTime.now();

              final history = RecentAnime(
                id: data.id,
                episodeId: data.episodeId,
                currentEp: data.currentEp,
               
                title: data.title,
                image: data.image,
                createAt: now.toString(), type: data.type, imageEps: data.imageEps,
              );
              if (historyManager.epsIdList.contains(data.episodeId)) {
                historyManager.removeHistory(data.episodeId);
                historyManager.addHistoryAnime(history);
              } else {
                historyManager.addHistoryAnime(history);
              }

              await Get.to(
                WebViewScreen(
                  slug: data.episodeId,
                  detail: ApiService().detail(data.id),
                  currentIndex: int.parse(data.currentEp),
                  prevPage: "Home",
              image: data.image,

                ),
              );
            },
            icon: Icon(Icons.play_arrow),
          )
        ],
      ),
    );
  }
}
