// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';
import 'package:my_anime_stream/pages/detail/component/isi.dart';
import 'package:my_anime_stream/pages/detail/component/listEpisode.dart';
import 'package:my_anime_stream/pages/detail/component/title.dart';

class Detail extends StatefulWidget {
  final images;
  final slug;
  const Detail({super.key, required this.images, required this.slug});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Future detail;

  @override
  void initState() {
    detail = ApiService().detail(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        key: UniqueKey(),
                        cacheManager: CustomCacheManager.instance,
                        imageUrl: widget.images,
                        height: size.height / 4,
                        width: size.width,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              CupertinoIcons.xmark,
                              color: Colors.white,
                              size: size.width * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 25.0, left: 15, right: 15, bottom: 20),
                child: Column(
                  children: [
                    Top(detail: detail, size: size),
                    SizedBox(
                      height: size.height * 0.023,
                    ),
                    Isi(detail: detail, size: size),
                    SizedBox(
                      height: size.height * 0.023,
                    ),
                    ListEpisode(detail: detail)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
