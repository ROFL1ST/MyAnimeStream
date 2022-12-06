import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/pages/about/about.dart';
import 'package:my_anime_stream/pages/favorite/favoritePages.dart';
import 'package:my_anime_stream/pages/genre/genreList.dart';
import 'package:my_anime_stream/pages/history/historyPages.dart';

class Draw extends StatefulWidget {
  const Draw({super.key});

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Drawer(
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
            // ListTile(
            //   onTap: () => Get.to(GenreListPage()),
            //   hoverColor: Colors.white,
            //   title: const Text('Genre'),
            //   leading: const Icon(Icons.list_outlined),
            // ),
            ListTile(
              onTap: () => Get.to(() => About()),
              hoverColor: Colors.white,
              title: const Text('About'),
              leading: const Icon(Icons.info),
            ),
          ],
        ),
      ),
    );
  }
}
