import 'package:flutter/material.dart';
import 'package:my_anime_stream/common/colors.dart';

class Top extends StatefulWidget {
  final detail;
  final size;
  final episode;
  const Top({super.key, required this.detail, required this.size, this.episode});

  @override
  State<Top> createState() => _TopState();
}

class _TopState extends State<Top> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return titleLoading(widget.size);
            if (snapshot.hasError) return Text("");
            if (snapshot.hasData) return title(snapshot.data, widget.size);
            return Text("Kosong");
          },
          future: widget.detail,
        ),
        Container(
          decoration: BoxDecoration(
              color: cardBg, borderRadius: BorderRadius.circular(25)),
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.favorite_outline)),
        ),
      ],
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
            data.title,
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
