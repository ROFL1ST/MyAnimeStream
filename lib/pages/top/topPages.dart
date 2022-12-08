// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/pages/detail/detail.dart';
import 'package:my_anime_stream/pages/episode/webview_screen.dart';
import 'package:my_anime_stream/pages/home/components/cache_image_with_cachemanager.dart';
import 'package:my_anime_stream/pages/search/component/resultLoading.dart';

class TopPages extends StatefulWidget {
  const TopPages({super.key});

  @override
  State<TopPages> createState() => _TopPagesState();
}

class _TopPagesState extends State<TopPages> {
  int _pageIndex = 1;
  bool hasNoMoreResult = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          "Top Anime",
          style: kTitleDetailStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            ApiService().top(_pageIndex);
          });
        },
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: ApiService().top(_pageIndex),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Loading(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        children: [
                          Text(
                            "No Connetion",
                            style: kSubtitleTextStyle,
                          ),
                          TextButton(
                            onPressed: () {
                              ApiService().top(_pageIndex);
                            },
                            child: Text("Retry"),
                            style: TextButton.styleFrom(
                              backgroundColor: kFavIconColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: itemBuilder(snapshot.data.results, size),
                    );
                  } else {
                    return Text("No Data");
                  }
                },
              ),
            ),
            Align(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        onTap: () {
                          if (_pageIndex != 1 && _pageIndex > 1) {
                            _pageIndex--;

                            setState(() {});
                          }
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                          decoration: BoxDecoration(
                              // color: tkLightGreen,
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.arrow_back_ios_new_rounded,
                              ),
                              Text('Prev'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Text(_pageIndex.toString(),
                          style: kTitleTextStyle.copyWith(color: Colors.black)),
                    ),
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        onTap: () {
                          if (!hasNoMoreResult) {
                            _pageIndex++;

                            setState(() {});
                          }
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                          decoration: BoxDecoration(
                              // color: tkLightGreen,
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )),
                          child: Row(
                            children: const [
                              Text('Next'),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemBuilder(data, size) {
    return Container(
      width: size.width,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: data.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: .56,
          crossAxisSpacing: 30,
          mainAxisSpacing: 40,
          maxCrossAxisExtent: 220,
        ),
        itemBuilder: (context, index) {
          return card(data[index], size);
        },
      ),
    );
  }

  Widget card(data, size) {
    return InkWell(
        onTap: () {
          Get.to(Detail(
            images: data.image,
            slug: data.id,
            type: data.type,
          ));
        },
        child: Container(
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
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      AutoSizeText(
                        data.title.romaji,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: kListTitleStyle,
                      ),
                      Text(
                        "Released : ${data.releaseDate}",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: kListSubtitle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        // child: Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       image: DecorationImage(
        //           image: NetworkImage(data.image), fit: BoxFit.cover)),
        // ),
        );
  }
}
