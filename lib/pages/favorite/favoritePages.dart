// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/favoriteManager.dart';

import 'package:my_anime_stream/pages/detail/detail.dart';
import 'package:my_anime_stream/pages/home/components/cache_image_with_cachemanager.dart';

class FavoritePages extends StatefulWidget {
  const FavoritePages({super.key});

  @override
  State<FavoritePages> createState() => _FavoritePagesState();
}

class _FavoritePagesState extends State<FavoritePages> {
  final FavoriteManager favoriteManager = Get.put(FavoriteManager());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite",
          style: kTitleDetailStyle,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: bg,
      body: SafeArea(
        child: FutureBuilder<void>(
          future: favoriteManager.loadFavoriteFromDatabase(),
          builder: (context, AsyncSnapshot snapshot) =>
              GetBuilder<FavoriteManager>(
            builder: (_) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: favoriteManager.favorites.length != 0
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: favoriteManager.favorites.length,
                        itemBuilder: (context, index) {
                          return card(
                              favoriteManager.favorites[index], size, index);
                        },
                      )
                    : const Center(
                        child: Text(
                          "No Favorite Yet",
                          style: kSubtitleDetailStyle,
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  Widget card(data, size, index) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        // ignore: sort_child_properties_last
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              var favorite = favoriteManager.favorites[index];
              favoriteManager.removeFromFavorite(favorite);
              Get.snackbar(
                  favorite.title, 'Removed from bookmark successfully!',
                  backgroundColor: Colors.black38,
                  duration: const Duration(milliseconds: 1300),
                  snackPosition: SnackPosition.BOTTOM);
            },
            label: 'Delete',
            icon: Icons.delete,
            foregroundColor: Colors.redAccent,
                     backgroundColor: cardBg,

          ),
        ],

        dismissible: DismissiblePane(
          onDismissed: () {
            var favorite = favoriteManager.favorites[index];
            favoriteManager.removeFromFavorite(favorite);
            Get.snackbar(favorite.title, 'Removed from bookmark successfully!',
                backgroundColor: Colors.black38,
                duration: const Duration(milliseconds: 1300),
                snackPosition: SnackPosition.BOTTOM);
          },
        ),
      ),
      key: UniqueKey(),
      child: InkWell(
        onTap: () {
          Get.to(
            Detail(
              images: data.image,
              slug: data.id,
              type: data.type,
            ),
          );
        },
        child: Container(
          width: size.width,
          height: size.height * 0.12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          height: size.height * 0.01,
                        ),
                        SizedBox(
                          width: size.width * 0.55,
                          child: AutoSizeText(
                            data.genre,
                            maxLines: 1,
                            style: kListSubtitle,
                            minFontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              IconButton(
                onPressed: () {
                  var favorite = favoriteManager.favorites[index];
                  favoriteManager.removeFromFavorite(favorite);
                  Get.snackbar(
                      favorite.title, 'Removed from bookmark successfully!',
                      backgroundColor: Colors.black38,
                      duration: const Duration(milliseconds: 1300),
                      snackPosition: SnackPosition.BOTTOM);
                },
                icon: Icon(
                  Icons.favorite,
                  color: kFavIconColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
