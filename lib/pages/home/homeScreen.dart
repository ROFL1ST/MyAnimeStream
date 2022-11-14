// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/pages/home/components/airing.dart';
import 'package:my_anime_stream/pages/home/components/carousel.dart';
import 'package:my_anime_stream/pages/home/components/favorite.dart';
import 'package:my_anime_stream/pages/home/components/recent.dart';

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
      recent = ApiService().recent();
    });
  }

  void refreshAll() {
    setState(() {
      top = ApiService().top();
      recent = ApiService().recent();
    });
  }

  @override
  void initState() {
    top = ApiService().top();
    recent = ApiService().recent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "MyAnimeStream",
            style: kTitleTextStyle,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
                onPressed: () {},
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
            physics: BouncingScrollPhysics(),
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
                    padding: const EdgeInsets.only(top: 20.0, left: 10),
                    child: Column(
                      children: [
                        Airing(
                          size: size,
                          top: top,
                          refreshCarousel: refreshCarousel,
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Recent(
                          size: size,
                          recent: recent,
                          refreshRecent: refreshRecent,
                        ),
                        SizedBox(
                          height: size.height * 0.02,
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
