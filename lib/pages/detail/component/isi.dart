import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';
import 'package:html/parser.dart';

class Isi extends StatefulWidget {
  final detail;
  final size;

  const Isi({
    super.key,
    required this.detail,
    required this.size,
  });

  @override
  State<Isi> createState() => _IsiState();
}

class _IsiState extends State<Isi> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: widget.detail,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: cardBg,
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Synopsis",
                          style: kTitleDetailStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: cardBg,
                              ),
                              height: size.height * 0.015,
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
                              height: size.height * 0.015,
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
                              height: size.height * 0.015,
                              width: size.width * 0.25,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          if (snapshot.hasError) return Text("Error");
          if (snapshot.hasData) {
            String _parseHtmlString(String htmlString) {
              final document = parse(htmlString);
              final String parsedString =
                  parse(document.body?.text).documentElement!.text;

              return parsedString;
            }

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: cardBg,
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Synopsis",
                            style: kTitleDetailStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      snapshot.data.description != null
                          ? !isOpen
                              ? AutoSizeText(
                                  _parseHtmlString(
                                      snapshot.data.description.toString()),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  // textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 12),
                                )
                              : Column(
                                  children: [
                                    AutoSizeText(
                                      _parseHtmlString(
                                          snapshot.data.description.toString()),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                )
                          : Row(
                            children: [
                              Text("No Desc"),
                            ],
                          )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Text("Kosong");
          }
        });
  }
}
