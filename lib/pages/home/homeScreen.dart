// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/historyManager.dart';
import 'package:my_anime_stream/pages/favorite/favoritePages.dart';
import 'package:my_anime_stream/pages/history/historyPages.dart';
import 'package:my_anime_stream/pages/home/components/airing.dart';
import 'package:my_anime_stream/pages/home/components/carousel.dart';
import 'package:my_anime_stream/pages/home/components/continue.dart';
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

  void refreshCarousel() {
    setState(() {
      top = ApiService().top();
    });
  }

  void refreshRecent() {
    setState(() {
      recent = ApiService().recent(1);
    });
  }

  void refreshAll() {
    setState(() {
      top = ApiService().top();
      recent = ApiService().recent(1);
    });
  }

  @override
  void initState() {
    top = ApiService().top();
    recent = ApiService().recent(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: kDarkBlue.withOpacity(1),
          child: ListView(
            children: [
              SizedBox(
                height: size.height * 0.3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Image.asset(
                          'assets/images/mekakucity-actors-wallpapers.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black45,
                    ),
                    Positioned(
                      right: 5,
                      left: 5,
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 60,
                        decoration: BoxDecoration(
                            color: kDarkBlue.withOpacity(.7),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Text(
                          'MyNime',
                          style: kTitleBannerStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: () => Get.to(FavoritePages()),
                hoverColor: Colors.white,
                title: const Text('Favorites'),
                leading: const Icon(Icons.favorite),
              ),
              ListTile(
                onTap: () => Get.to(HistoryPages(
                  detail: null,
                )),
                hoverColor: Colors.white,
                title: const Text('History'),
                leading: const Icon(Icons.history),
              ),
              ListTile(
                hoverColor: Colors.white,
                title: const Text('About'),
                leading: const Icon(Icons.info),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "MyNime",
            style: kTitleTextStyle,
          ),
        ),
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
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshAll();
        },
        child: SafeArea(
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
                    top: top,
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
