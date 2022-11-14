import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/common/colors.dart';

class Favorite extends StatefulWidget {
  final size;
  const Favorite({super.key, required this.size});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Favorites",
              style: kTitleTextStyle,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.arrow_circle_right),
            )
          ],
        ),
        listBuilder(widget.size)
      ],
    );
  }

  Widget listBuilder(size) {
    List data = [
      {
        "name": "Go-Toubun",
        "genre": ["comedy", "Harem", "Romance"],
        "image": "https://gogocdn.net/cover/gotoubun-no-hanayome.png",
        "favorite": true,
      },
      {
        "name": "One Piece",
        "genre": ["Action", "Adventure", "Drama"],
        "image": "https://gogocdn.net/images/anime/One-piece.jpg",
        "favorite": true,
      },
      {
        "name": "Hyouka",
        "genre": ["Action", "Adventure", "Drama"],
        "image": "https://gogocdn.net/images/anime/H/hyouka.jpg",
        "favorite": false,
      },
    ];
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      height: data.length * 110,
      width: size.width,
      child: Column(
        children: data.length != 0
            ? data.map((e) => card(e, size)).toList()
            : [
                Center(
                  child: Container(
                    height: size.height * 0.27,
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Connection"),
                      ],
                    ),
                  ),
                )
              ],
      ),
    );
  }

  Widget card(data, size) {
    return Container(
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
                  data["image"],
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
                    Text(
                      data["name"],
                      style: kListTitleStyle,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      data["genre"].join(", "),
                      style: kListSubtitle,
                    )
                  ],
                ),
              )
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: data["favorite"] == true
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_outline),
          )
        ],
      ),
    );
  }
}
