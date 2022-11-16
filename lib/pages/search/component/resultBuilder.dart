// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/pages/detail/detail.dart';
import 'package:my_anime_stream/pages/home/components/cache_image_with_cachemanager.dart';

class ResultBuilder extends StatefulWidget {
  final data;
  final retry;
  const ResultBuilder({super.key, required this.data, this.retry});

  @override
  State<ResultBuilder> createState() => _ResultBuilderState();
}

class _ResultBuilderState extends State<ResultBuilder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        
        physics: BouncingScrollPhysics(),
        itemCount: widget.data.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: .56,
          crossAxisSpacing: 30,
          mainAxisSpacing: 40,
          maxCrossAxisExtent: 220,
        ),
        itemBuilder: (context, index) {
          return card(widget.data[index], size);
        },
      ),
    );
  }

  Widget card(data, size) {
    return InkWell(
        onTap: () {
          Get.to(Detail(images: data.image, slug: data.id));
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
                        data.title,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: kListTitleStyle,
                      ),
                      Text(
                        data.releaseDate.toString(),
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
