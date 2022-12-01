// ignore_for_file: curly_braces_in_flow_control_structures, sort_child_properties_last

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';
import 'package:my_anime_stream/pages/detail/detail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Carousel extends StatefulWidget {
  final size;
  final popular;
  final refreshCarousel;
  const Carousel(
      {super.key,
      required this.size,
      required this.popular,
      required this.refreshCarousel});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return loadingCarousel(widget.size);
        if (snapshot.hasError)
          return errorCarousel(widget.size, widget.refreshCarousel);
        if (snapshot.hasData) {
          var data = snapshot.data.results;

          return listBuilder(data, widget.size);
          // return Container();s
        } else {
          return Text("Kosong");
        }
      },
      future: widget.popular,
    );
  }

  Widget listBuilder(data, size) {
    return CarouselSlider.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, index, realIndex) {
        return cardCarousel(data, index, size);
      },
      options: CarouselOptions(
          height: size.height * 0.2,
          autoPlay: true,
          initialPage: 0,
          // enlargeCenterPage: true,
          viewportFraction: 0.92),
    );
  }

  Widget cardCarousel(data, index, size) {
    // print(data[0].image);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          Get.to(Detail(
            images: data[index].image,
            slug: data[index].id,
            type: data[index].type,
          ));
        },
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    data[index].image,
                    cacheManager: CustomCacheManager.instance,
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  opacity: 0.8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  data[index].title.romaji,
                  style: kTitleBannerStyle,
                ),
              ),
            ],
          ),
          width: size.width,
        ),
      ),
    );
  }

  Widget loadingCarousel(size) {
    return CarouselSlider.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, index, realIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Center(
            child: Container(
              height: size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: cardBg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Container(
                      height: size.height * 0.02,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: cardBg,
                      ),
                    ),
                  ),
                ],
              ),
              width: size.width,
            ),
          ),
        );
      },
      options: CarouselOptions(
          height: size.height * 0.2,
          initialPage: 0,
          // enlargeCenterPage: true,
          viewportFraction: 0.92),
    );
  }

  Widget errorCarousel(size, refresh) {
    return CarouselSlider.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, index, realIndex) {
        return Center(
          child: Container(
            height: size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cardBg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      children: [
                        Text("No Connection"),
                        ElevatedButton(
                          onPressed: refresh,
                          child: Text("Retry"),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(kFavIconColor)),
                        )
                      ],
                    )),
              ],
            ),
            width: size.width,
          ),
        );
      },
      options: CarouselOptions(
          height: size.height * 0.2,
          // autoPlay: true,
          initialPage: 0,
          enlargeCenterPage: true,
          viewportFraction: 0.85),
    );
  }
}
