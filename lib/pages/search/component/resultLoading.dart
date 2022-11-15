// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_anime_stream/common/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: .56,
          crossAxisSpacing: 30,
          mainAxisSpacing: 40,
          maxCrossAxisExtent: size.height * 0.2,
        ),
        itemBuilder: (context, index) {
          return card(size);
        });
  }

  Widget card(size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cardBg,
      ),
    );
  }
}
