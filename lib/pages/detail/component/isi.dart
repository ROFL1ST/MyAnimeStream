import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';

class Isi extends StatefulWidget {
  final detail;
  final size;

  const Isi({super.key, required this.detail, required this.size});

  @override
  State<Isi> createState() => _IsiState();
}

class _IsiState extends State<Isi> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return isiLoading(widget.size);
        if (snapshot.hasError) return Text("error");
        if (snapshot.hasData) return isi(snapshot.data, widget.size);
        return Text("Kosong");
      },
      future: widget.detail,
    );
  }

  Widget isi(data, size) {
    print(isOpen);
    return InkWell(
      onTap: () {
        setState(() {
          isOpen = !isOpen;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cardBg,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  key: UniqueKey(),
                  cacheManager: CustomCacheManager.instance,
                  imageUrl: data.image,
                  height: size.height * 0.1,
                  width: size.width * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: size.width * 0.08,
              ),
              Container(
                width: size.width * 0.57,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    isOpen
                        ? Text(data.description)
                        : AutoSizeText(
                            "${data.description}",
                            maxLines: 5,
                            maxFontSize: 14,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget isiLoading(size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cardBg,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: size.height * 0.1,
                  width: size.width * 0.2,
                  decoration: BoxDecoration(color: bg),
                )),
            SizedBox(
              width: size.width * 0.08,
            ),
            Container(
              width: size.width * 0.57,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: cardBg,
                    ),
                    height: size.height * 0.01,
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
                    height: size.height * 0.01,
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
                    height: size.height * 0.01,
                    width: size.width * 0.2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
