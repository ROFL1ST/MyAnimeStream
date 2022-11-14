import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/pages/episode/episode.dart';

class ListEpisode extends StatefulWidget {
  final detail;
  const ListEpisode({super.key, required this.detail});

  @override
  State<ListEpisode> createState() => _ListEpisodeState();
}

class _ListEpisodeState extends State<ListEpisode> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return loading(size);
        if (snapshot.hasError) return Text("Error");
        if (snapshot.hasData) return listBuilder(snapshot.data, size);
        return Text("Kosong");
      },
      future: widget.detail,
    );
  }

  Widget listBuilder(data, size) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text(
              "Episodes",
              style: kTitleTextStyle,
            ),
            Text(
              "Total : ${data.totalEpisodes}",
              style: kSubtitleTextStyle,
            ),
          ],
        ),
        Column(
          children:
              data.episodes.map<Widget>((e) => episodeCard(e, size)).toList(),
        )
      ],
    );
    // list episode
  }

  Widget episodeCard(data, size) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: InkWell(
        onTap: () {
          Get.to(Episode(
            slug: data.id,
            url: data.url,
            detail: widget.detail,
            eps: data.number.toString(),
          ));
        },
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cardBg,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Episode ${data.number.toString()}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget loading(size) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text(
              "Episodes",
              style: kTitleTextStyle,
            ),
            Text(
              "Total : loading...",
              style: kSubtitleTextStyle,
            ),
          ],
        ),
        Column(children: [
          episodeLoading(size),
          episodeLoading(size),
          episodeLoading(size),
          episodeLoading(size),
          episodeLoading(size),
          episodeLoading(size),
          episodeLoading(size),
        ])
      ],
    );
  }

  Widget episodeLoading(size) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cardBg,
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
          ),
        ),
      ),
    );
  }
}
