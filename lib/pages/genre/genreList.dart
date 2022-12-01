// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/pages/genre/selected/genreSelected.dart';

class GenreListPage extends StatefulWidget {
  const GenreListPage({super.key});

  @override
  State<GenreListPage> createState() => _GenreListPageState();
}

class _GenreListPageState extends State<GenreListPage> {
  List genre = [
    {"name": "Action"},
    {"name": "Adventure"},
    {"name": "Cars"},
    {"name": "Comedy"},
    {"name": "Drama"},
    {"name": "Fantasy"},
    {"name": "Horror"},
    {"name": "Mahou Shoujo"},
    {"name": "Mecha"},
    {"name": "Psychological"},
    {"name": "Romance"},
    {"name": "Sci-Fi"},
    {"name": "Slice of Life"},
    {"name": "Sports"},
    {"name": "Supernatural"},
    {"name": "Thriller"}
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Genre",
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
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(genre[index]["name"]),
              onTap: () {
                Get.to(() => GenreSelected(
                      genreName: genre[index]["name"],
                    ));
              },
            );
          },
          itemCount: genre.length,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
                height: size.width / 15, child: Divider(thickness: 0.8));
          },
        ),
      )),
    );
  }
}
