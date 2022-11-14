import 'dart:ui' as ui;
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/media_quality_manager.dart';
import 'package:my_anime_stream/helpers/webview_manager.dart';
import 'package:my_anime_stream/pages/episode/component/video_player_screen.dart';
import 'package:my_anime_stream/pages/episode/component/webview_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
// import 'dart:math';
import '../../../helpers/tako_play_web_view.dart';

class Player extends StatefulWidget {
  final url;
  final slug;
  final detail;
  final eps;
  const Player(
      {super.key, required this.url, this.slug, this.detail, this.eps});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  BetterPlayerController? _betterPlayerController;
  // final IFrameElement _iframeElement = IFrameElement();
  final GlobalKey webViewKey = GlobalKey();
  final webViewManagerController = Get.put(WebViewManager());
  final mediaFetchController = Get.put(MediaQualityManager());
  Map<String, String> resolutions = {};
  List<String> _qualityList = [];
  String _filteredUrl = '';

  var hasError = false.obs;
  late final String mediaUrl;

  List<String> ads() {
    List<String> list = [];
    list.add("imasdk.googleapis.com");
    list.add("rtmark.net");
    list.add("offerimage.com");
    list.add("xadsmart.com");
    list.add("cloudfront.net");
    list.add("in-page-push.com");
    return list;
  }

  @override
  void initState() {
    mediaFetchController.getVideoQuality();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    fetchVideoFile();
  }

  // final Widget _iFrameElement = HtmlElementView(

  //   viewType: 'iframeElement',
  //   key: UniqueKey(),
  // );
  Future<void> fetchVideoFile() async {
    if (webViewManagerController.isWebView) {
      var mediaUrl =
          await ApiService().fetchIframeEmbedded(widget.url).catchError((_) {
        Get.dialog(const AlertDialog(
          backgroundColor: Colors.black,
          content: Text('An Error Occurred'),
        ));
        Get.back();
      });
      if (!mounted) return;
      await Get.to(
          WebViewScreen(
            slug: widget.slug,
            detail: widget.detail,
            episode: widget.eps,
            mediaUrl: widget.url,
          ),
          arguments: {
            'mediaUrl': 'https:' + mediaUrl,
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0,
            child: webViewManagerController.isWebView
                ? const SizedBox()
                : FutureBuilder<String>(
                    future: ApiService().fetchIframeEmbedded(widget.url),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox.fromSize(
                          size: Size(MediaQuery.of(context).size.width / 1.5,
                              MediaQuery.of(context).size.height / 1.5),
                          child: TakoPlayWebView(
                            initialUrl: 'https:${snapshot.data}',
                            onLoadingFinished: (_webViewController) async {
                              mediaUrl = snapshot.data!;
                              // Ads Block
                              Future.delayed(Duration(milliseconds: 1), () {
                                Get.off(
                                    WebViewScreen(
                                      slug: widget.slug,
                                      detail: widget.detail,
                                      episode: widget.eps,
                                      mediaUrl: widget.url,
                                    ),
                                    arguments: {
                                      'mediaUrl': 'https:' + mediaUrl,
                                    });
                              });
                            },
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
          ),
          Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(color: bg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Visibility(
                    visible: !hasError.value,
                    child: Text(
                      'Please Wait ...',
                      style: kSubtitleDetailStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
