import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_anime_stream/common/colors.dart';

const String _heroDevCard = 'dev-card-hero';

class DevCard extends StatelessWidget {
  const DevCard({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroDevCard,
          child: Material(
            color: kCardColorDark,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  SizedBox(
                    width: size.width * 0.6,
                    child: AutoSizeText(
                        "Hai Everyone, thanks for using my app, Hope You Enjoy the app. Leave your opinion on my github or contact me if you found a bug or even want to build your imaginary app with me. I'm all in 😊"),
                  ),
                  Divider(
                    color: cardBg,
                    thickness: 0.2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Ok"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
