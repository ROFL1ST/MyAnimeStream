// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';

class CharactersBuilder extends StatefulWidget {
  final detail;

  const CharactersBuilder({super.key, this.detail});

  @override
  State<CharactersBuilder> createState() => _CharactersBuilderState();
}

class _CharactersBuilderState extends State<CharactersBuilder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Characters",
          style: kTitleTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(
            // bottom: 6,

            top: 18,
          ),
          child: SizedBox(
            height: size.height * 0.14,
            width: size.width,
            child: FutureBuilder(
              future: widget.detail,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            // bottom: 6,

                            right: 18,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: size.height * 0.09,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: cardBg),
                                child: Padding(padding: EdgeInsets.all(8)),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Container(
                                width: size.width * 0.1,
                                height: size.height * 0.01,
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                if (snapshot.hasError) return Text("Error");
                if (snapshot.hasData) {
                  return snapshot.data.characters.length != 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.characters.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                // bottom: 6,

                                right: 18,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.09,
                                    width: size.width * 0.2,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(105),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data.characters[index].image,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            height: size.height * 0.09,
                                            width: size.width * 0.2,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: cardBg),
                                            child: Padding(
                                                padding: EdgeInsets.all(8)),
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.14,
                                    child: AutoSizeText(
                                      snapshot.data.characters[index].name
                                              .full ??
                                          "",
                                      maxLines: 1,
                                      maxFontSize: 16,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            );
                          })
                      : Text("No Characters");
                } else {
                  return Text("Kosong");
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
