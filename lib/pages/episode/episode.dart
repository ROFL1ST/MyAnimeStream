import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/webview_manager.dart';
import 'package:my_anime_stream/pages/episode/component/player.dart';
import 'package:video_player/video_player.dart';

class Episode extends StatefulWidget {
  final url;
  final slug;
  final detail;
  final eps;
  const Episode({super.key, required this.slug, required this.url, this.detail, this.eps});

  @override
  State<Episode> createState() => _EpisodeState();
}

class _EpisodeState extends State<Episode> {
  late Future episode;

  final GlobalKey webViewKey = GlobalKey();
  final webViewManagerController = Get.put(WebViewManager());
  @override
  void initState() {
    episode = ApiService().episode(widget.slug);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(child: Player(url: widget.url, slug: widget.slug, detail: widget.detail, eps: widget.eps,)),
    );
  }
}
