import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_anime_stream/pages/episode/component/_ControlsOverlay.dart';
import 'package:video_player/video_player.dart';
import 'package:video_viewer/domain/bloc/controller.dart';
import 'package:video_viewer/video_viewer.dart';

class Player extends StatefulWidget {
  final url;
  final orientation;
  const Player({super.key, required this.url, required this.orientation});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final VideoViewerController controller = VideoViewerController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio:
            widget.orientation == Orientation.landscape ? 19.5 / 9 : 4 / 2.885,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            FutureBuilder<Map<String, VideoSource>>(
              future: VideoSource.fromM3u8PlaylistUrl(
                widget.url,
                formatter: (quality) => quality == "Auto"
                    ? "Automatic"
                    : "${quality.split("x").last}p",
              ),
              builder: (_, data) {
                log("HAIIIIIII $data");

                return data.hasData
                    ? VideoViewer(
                        source: data.data!,
                        onFullscreenFixLandscape: true,
                        style: VideoViewerStyle(
                          thumbnail: Image.network(
                            "https://play-lh.googleusercontent.com/aA2iky4PH0REWCcPs9Qym2X7e9koaa1RtY-nKkXQsDVU6Ph25_9GkvVuyhS72bwKhN1P",
                          ),
                        ),
                      )
                    : CircularProgressIndicator();
              },
            )
          ],
        ));
  }
}
