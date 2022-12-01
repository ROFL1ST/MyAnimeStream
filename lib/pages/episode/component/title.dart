// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/API/model/favorite.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/favoriteManager.dart';

class Top extends StatefulWidget {
  final detail;
  final size;
  final episode;
  const Top(
      {super.key, required this.detail, required this.size, this.episode});

  @override
  State<Top> createState() => _TopState();
}

class _TopState extends State<Top> {
  final FavoriteManager favoriteManager = Get.put(FavoriteManager());
  late Future hai;

  @override
  void initState() {
    hai = favoriteManager.loadFavoriteFromDatabase();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleLoading(widget.size),
              Container(
                decoration: BoxDecoration(
                    color: cardBg, borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                ),
              ),
            ],
          );
        if (snapshot.hasError) return Text("");
        if (snapshot.hasData)
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title(snapshot.data, widget.size),
              GetBuilder<FavoriteManager>(
                builder: (_) => Container(
                  decoration: BoxDecoration(
                      color: cardBg, borderRadius: BorderRadius.circular(25)),
                  child: IconButton(
                    icon: favoriteManager.ids.contains(snapshot.data.id)
                        ? Icon(
                            Icons.favorite,
                            color: kFavIconColor,
                          )
                        : Icon(Icons.favorite_outline),
                    onPressed: () {
                      final item = Favorite(
                        id: snapshot.data.id,
                        title: snapshot.data.title.romaji,
                        type: snapshot.data.type,
                        image: snapshot.data.image,
                        genre: snapshot.data.genres.join(", "),
                      );
                      if (favoriteManager.ids
                          .contains(snapshot.data.id.toString())) {
                        favoriteManager.removeFromFavorite(item);
                        Get.snackbar(
                          snapshot.data.title.romaji,
                          "Ahh,${snapshot.data.title.romaji} Removed From Favorite 😨",
                          backgroundColor: Colors.black38,
                          duration: const Duration(milliseconds: 1300),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        favoriteManager.addToFavorite(item);
                        Get.snackbar(snapshot.data.title.romaji,
                            'Yeay!!, ${snapshot.data.title.romaji} Added to bookmark successfully! 😊',
                            backgroundColor: Colors.black38,
                            duration: const Duration(milliseconds: 1300),
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                  ),
                ),
              )
            ],
          );
        return Text("Kosong");
      },
      future: widget.detail,
    );
  }

  Widget title(data, size) {
    return Container(
      width: size.width / 1.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.genres.join(", "),
            style: kSubtitleDetailStyle,
          ),
          SizedBox(
            height: size.height * 0.005,
          ),
          Text(
            data.title.romaji,
            style: kTitleDetailStyle,
          ),
          SizedBox(
            height: size.height * 0.005,
          ),
          Text(
            "Episode ${widget.episode}",
            style: kSubtitleDetailStyle,
          )
        ],
      ),
    );
  }

  Widget titleLoading(size) {
    return Container(
      width: size.width / 1.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cardBg,
            ),
            height: size.height * 0.02,
            width: size.width * 0.6,
          ),
          SizedBox(
            height: size.height * 0.007,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cardBg,
            ),
            height: size.height * 0.02,
            width: size.width * 0.4,
          ),
          SizedBox(
            height: size.height * 0.007,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cardBg,
            ),
            height: size.height * 0.02,
            width: size.width * 0.2,
          ),
        ],
      ),
    );
  }
}
