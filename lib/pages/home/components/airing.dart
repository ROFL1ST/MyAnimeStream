import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';
import 'package:my_anime_stream/helpers/hero_dialogue_route.dart';
import 'package:my_anime_stream/pages/detail/detail.dart';
import 'package:my_anime_stream/pages/home/components/cache_image_with_cachemanager.dart';
import 'package:my_anime_stream/pages/home/components/cardDialogue.dart';
import 'package:my_anime_stream/pages/top/topPages.dart';

class Airing extends StatefulWidget {
  final size;
  final top;
  final refreshCarousel;

  const Airing(
      {super.key,
      required this.size,
      required this.top,
      required this.refreshCarousel});

  @override
  State<Airing> createState() => _AiringState();
}

class _AiringState extends State<Airing> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Top Airing",
              style: kTitleTextStyle,
            ),
            IconButton(
              onPressed: () {
                Get.to(
                  TopPages(),
                );
              },
              icon: Icon(Iconsax.arrow_circle_right),
            )
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
          future: widget.top,
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
      onLongPress: () {
        Navigator.of(context).push(HeroDialogRoute(builder: (context) {
          return CardDialogue(
            data: data,
            size: size,
            from: 1,
          );
        }));
      },
      onTap: () {
        Get.to(Detail(
          images: data.image,
          slug: data.id,
          type: data.type,
        ));
      },
      child: Hero(
        tag: data.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            key: UniqueKey(),
            cacheManager: CustomCacheManager.instance,
            // height: 200,
            // width: 180,
            fit: BoxFit.cover,
            imageUrl: data.image.toString(),
            placeholder: (context, url) => cardLoading(size),
          ),
        ),
      ),
      // child: Container(
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(10),
      //       image: DecorationImage(
      //           image: NetworkImage(data.image), fit: BoxFit.cover)),
      // ),
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
              onPressed: widget.refreshCarousel,
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
