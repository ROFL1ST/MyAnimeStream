// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/pages/search/component/resultLoading.dart';

class GenreSelected extends StatefulWidget {
  final genreName;
  const GenreSelected({super.key, required this.genreName});

  @override
  State<GenreSelected> createState() => _GenreSelectedState();
}

class _GenreSelectedState extends State<GenreSelected> {
  int currentPage = 1;
  late Future genre;
  bool hasNoMoreResult = false;

  @override
  void initState() {
    genre = ApiService().genre(widget.genreName, currentPage);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          widget.genreName.toString(),
          style: kTitleDetailStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            genre = ApiService().genre(widget.genreName, currentPage);
          });
        },
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
              future: genre,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  // ignore: curly_braces_in_flow_control_structures
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Loading(),
                  );
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          "No Connetion",
                          style: kSubtitleTextStyle,
                        ),
                        TextButton(
                          onPressed: () {
                            genre = ApiService()
                                .genre([widget.genreName], currentPage);
                          },
                          child: Text("Retry"),
                          style: TextButton.styleFrom(
                            backgroundColor: kFavIconColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )
                      ],
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: itemBuilder(snapshot.data, size),
                  );
                } else {
                  return Text("No Data");
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget itemBuilder(data, size) {
    return Container();
  }
}
