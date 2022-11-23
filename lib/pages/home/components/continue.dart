// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
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

  @override
  void initState() {
    historyManager.loadHistoryFromDatabase();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Continue Watching",
              style: kTitleTextStyle,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.arrow_circle_right),
            )
          ],
        ),
        FutureBuilder<void>(
          future: historyManager.loadHistoryFromDatabase(),
          builder: (context, AsyncSnapshot snapshot) =>
              GetBuilder<HistoryManager>(
            builder: (_) => Container(
              margin: EdgeInsets.only(top: size.height * 0.01),
              height: 250,
              width: double.infinity,
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: historyManager.animeList.length,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: size.height * 0.16,
                      mainAxisSpacing: 25),
                  itemBuilder: (context, index) {
                    return card(historyManager.animeList[index], size, index);
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget card(data, size, index) {
    return InkWell(
        onTap: () {
          Get.to(
            WebViewScreen(
              slug: data.episodeId,
              detail: ApiService().detail(data.id),
              currentIndex: int.parse(data.currentEp) - 1,
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
                Container(
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
                        "Episode ${int.parse(data.currentEp) + 1}",
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
        ));
  }
}
