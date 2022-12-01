// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/favoriteManager.dart';
import 'package:my_anime_stream/pages/detail/detail.dart';
import 'package:my_anime_stream/pages/favorite/favoritePages.dart';

class Favorite extends StatefulWidget {
  final size;
  const Favorite({super.key, required this.size});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final FavoriteManager favoriteManager = Get.put(FavoriteManager());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Favorites",
              style: kTitleTextStyle,
            ),
            IconButton(
              onPressed: () {
                Get.to(FavoritePages());
              },
              icon: Icon(Iconsax.arrow_circle_right),
            )
          ],
        ),
        FutureBuilder<void>(
          future: favoriteManager.loadFavoriteFromDatabase(),
          builder: (context, AsyncSnapshot snapshot) =>
              GetBuilder<FavoriteManager>(
            builder: (_) => listBuilder(widget.size),
          ),
        ),
      ],
    );
  }

  Widget listBuilder(size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      // height: favoriteManager.favorites.length * 110,
      width: size.width,
      child: Column(
          children: favoriteManager.favorites.length != 0
              ? favoriteManager.favorites
                  .asMap()
                  .entries
                  .map((e) => card(e.value, size, e.key))
                  .toList()
              : [
                  const Padding(
                    padding: EdgeInsets.all(80.0),
                    child: Center(
                      child: Text(
                        "No Favorite Yet",
                        style: kSubtitleDetailStyle,
                      ),
                    ),
                  )
                ]),
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
