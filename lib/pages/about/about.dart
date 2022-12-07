// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/hero_dialogue_route.dart';
import 'package:my_anime_stream/pages/about/component/devCard.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("About"),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: ListView(children: [
        ListTile(
          title: Text("Version"),
          subtitle: Text("1.1.0 aniList-API"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              HeroDialogRoute(
                builder: (context) {
                  return DevCard();
                },
              ),
            );
          },
          title: Text("Developer"),
          subtitle: Text("Muhamad Danendra Pr"),
        ),
        ListTile(
          onTap: (() => launch(
              "https://github.com/ROFL1ST/MyAnimeStream/tree/anilist-API")),
          title: Text("Source Code"),
          subtitle:
              Text("https://github.com/ROFL1ST/MyAnimeStream/tree/anilist-API"),
        ),
        ListTile(
          onTap: () => launch("mailto:danendrapr55@gmail.com"),
          trailing: Icon(Icons.email),
          title: Text("Contact Me"),
          subtitle: Text("danendrapr55@gmail.com"),
        ),
        ListTile(
          onTap: () => launch("tel: +6285888768152"),
          trailing: Icon(Icons.phone),
          title: Text("Contact Me"),
          subtitle: Text("+6285888768152"),
        )
      ]),
    );
  }
}
