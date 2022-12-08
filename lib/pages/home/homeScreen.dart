// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/historyManager.dart';
import 'package:my_anime_stream/pages/favorite/favoritePages.dart';
import 'package:my_anime_stream/pages/genre/genreList.dart';
import 'package:my_anime_stream/pages/history/historyPages.dart';
import 'package:my_anime_stream/pages/home/components/airing.dart';
import 'package:my_anime_stream/pages/home/components/carousel.dart';
import 'package:my_anime_stream/pages/home/components/continue.dart';
import 'package:my_anime_stream/pages/home/components/drawer.dart';
import 'package:my_anime_stream/pages/home/components/favorite.dart';
import 'package:my_anime_stream/pages/home/components/recent.dart';
import 'package:my_anime_stream/pages/search/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future top;
  late Future recent;
  late Future popular;

  void refreshCarousel() {
    setState(() {
      popular = ApiService().popular();
    });
  }

  void refreshRecent() {
    setState(() {
      recent = ApiService().recent(1);
    });
  }

  void refreshAll() {
    setState(() {
      top = ApiService().top(1);
      recent = ApiService().recent(1);
      popular = ApiService().popular();
    });
  }

  @override
  void initState() {
    top = ApiService().top(1);
    recent = ApiService().recent(1);
    popular = ApiService().popular();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Draw(),
      backgroundColor: bg,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   // elevation: 0,
      //   title: Padding(
      //     padding: const EdgeInsets.all(10.0),
      //     child: Text(
      //       "MyNime",
      //       style: kTitleTextStyle,
      //     ),
      //   ),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.all(10.0),
      //       child: IconButton(
      //           onPressed: () {
      //             Get.to(Search());
      //           },
      //           icon: Icon(
      //             Icons.search,
      //             color: Colors.white,
      //           )),
      //     )
      //   ],
      // ),

      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            [
          SliverAppBar(
            floating: true,
            title: Text(
              "MyNime",
              style: kTitleTextStyle,
            ),
            backgroundColor: bg,
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                    onPressed: () {
                      Get.to(Search());
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
              )
            ],
          )
        ],
        body: RefreshIndicator(
          onRefresh: () async {
            refreshAll();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Carousel(
                    refreshCarousel: refreshCarousel,
                    size: size,
                    popular: popular,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 10),
                    child: Column(
                      children: [
                        Continue(),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Airing(
                          size: size,
                          top: top,
                          refreshCarousel: refreshCarousel,
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Recent(
                          size: size,
                          recent: recent,
                          refreshRecent: refreshRecent,
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Favorite(size: size)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
