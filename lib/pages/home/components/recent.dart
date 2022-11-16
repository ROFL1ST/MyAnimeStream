import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';
import 'package:my_anime_stream/pages/detail/detail.dart';
import 'package:my_anime_stream/pages/episode/webview_screen.dart';

class Recent extends StatefulWidget {
  final size;
  final recent;
  final refreshRecent;
  const Recent(
      {super.key,
      required this.size,
      required this.recent,
      required this.refreshRecent});

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Updates",
              style: kTitleTextStyle,
            ),
          ],
        ),
        FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return listLoading(widget.size);
            if (snapshot.hasError) return error(widget.size);
            if (snapshot.hasData)
              return listBuilder(snapshot.data.results, widget.size);
            return Text("Kosong");
          },
          future: widget.recent,
        )
      ],
    );
  }

  Widget listBuilder(data, size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      height: size.height * 0.25,
      width: size.width,
      child: GridView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: data.length,
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: size.height * 0.16,
              mainAxisSpacing: 25),
          itemBuilder: (context, index) {
            return card(data[index], size);
          }),
    );
  }

  Widget card(data, size) {
    return InkWell(
      onTap: () {
        Get.to(
          WebViewScreen(
            slug: data.episodeId,
            detail: ApiService().detail(data.id),
            currentIndex: data.episodeNumber - 1,
            mediaUrl: data.url,
            prevPage: "Home",
          ),
        );
        // arah ke episode yg dituju
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              data.image,
              cacheManager: CustomCacheManager.instance,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 6),
              child: Container(
                height: size.height * 0.03,
                width: data.episodeNumber.toString().length * 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF535353).withOpacity(0.62),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.episodeNumber.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listLoading(size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      height: size.height * 0.27,
      width: size.width,
      child: GridView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: size.height * 0.16,
              mainAxisSpacing: 30),
          itemBuilder: (context, index) {
            return cardLoading(size);
          }),
    );
  }

  Widget cardLoading(size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cardBg,
      ),
    );
  }

  Widget error(size) {
    return Center(
      child: Container(
        height: size.height * 0.27,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No Connection"),
            ElevatedButton(
              onPressed: widget.refreshRecent,
              child: Text("Retry"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kFavIconColor)),
            )
          ],
        ),
      ),
    );
  }
}
