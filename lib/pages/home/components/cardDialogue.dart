import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/pages/home/components/cache_image_with_cachemanager.dart';

class CardDialogue extends StatefulWidget {
  final data;
  final size;
  final from;
  const CardDialogue(
      {super.key, required this.data, required this.size, required this.from});

  @override
  State<CardDialogue> createState() => _CardDialogueState();
}

class _CardDialogueState extends State<CardDialogue> {
  @override
  void initState() {
    // timer();
    // TODO: implement initState
    super.initState();
  }

  void timer() async {
    var duration = const Duration(seconds: 1);
    Timer(duration, () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Hero(
           tag: widget.from != 2 ? widget.data.id : widget.data.episodeId,
          child: Material(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: kCardColorDark,
            child: Container(
              height: widget.size.height / 2.5,
              width: widget.size.width / 1.7,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: NetworkImageWithCacheManager(
                            imageUrl: widget.data.image,
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
                          SizedBox(
                            width: widget.size.width / 2,
                            child: AutoSizeText(
                              widget.data.title.romaji,
                              maxLines: 2,
                              presetFontSizes: [14],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: kListTitleStyle,
                            ),
                          ),
                          (widget.from != 2)
                              ? AutoSizeText(
                                  "Released : ${widget.data.releaseDate}",
                                  maxLines: 2,
                                  presetFontSizes: [12],
                                  textAlign: TextAlign.center,
                                  style: kListSubtitle,
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
