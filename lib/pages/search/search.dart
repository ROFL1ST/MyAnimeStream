// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_anime_stream/API/apiService.dart';
import 'package:my_anime_stream/common/colors.dart';
import 'package:my_anime_stream/helpers/cache_manager.dart';
import 'package:my_anime_stream/pages/detail/detail.dart';
import 'package:my_anime_stream/pages/home/components/cache_image_with_cachemanager.dart';
import 'package:my_anime_stream/pages/search/component/resultBuilder.dart';
import 'package:my_anime_stream/pages/search/component/resultLoading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController controller;
  late Future result;
  var title = ''.obs;
  int _pageIndex = 1;
  bool hasNoMoreResult = false;

  var hasValue = false.obs;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.length >= 4) {
        title.value = _searchController.text;
        _pageIndex = 1;
        hasValue.value = true;
        result = ApiService().search(title.value, _pageIndex);
      }
    });
  }

  void retryVoid() {
    setState(() {
      result = ApiService().search(title.value, _pageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.back();
          },
        ),
        title: Container(
          // margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 1,
          ),
          width: size.width * 0.7,
          // height: size.height * 0.05,
          decoration: BoxDecoration(
            // color: cardBg,
            borderRadius: BorderRadius.circular(29),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              fillColor: cardBg,
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  _searchController.clear();
                  hasValue.value = false;
                },
              ),
              hintText: 'Search...',
              border: InputBorder.none,
              // contentPadding: EdgeInsets.all(20),
            ),
            onSubmitted: (val) {
              _saveToRecentSearches(val);
              result = ApiService().search(title.value, _pageIndex);
              _pageIndex = 1;
              hasValue.value = true;
              title.value = val;
            },
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        return hasValue.value
            ? FutureBuilder(
                future: ApiService().search(title.value, _pageIndex),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Loading(),
                    );
                  if (snapshot.hasError) {
                    return SizedBox(
                      height: size.height,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Connetion",
                              style: kSubtitleTextStyle.copyWith(
                                  color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                ApiService().search(title.value, _pageIndex);
                              },
                              child: Text(
                                "Retry",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: kFavIconColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    log("${snapshot.data.hasNextPage}");
                    (snapshot.data.hasNextPage)
                        ? _pageIndex
                        : (_pageIndex == 1)
                            ? _pageIndex = 1
                            : _pageIndex;
                    return (snapshot.data.results.length != 0)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, right: 15, left: 15),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ResultBuilder(
                                      data: snapshot.data.results,
                                      retry: retryVoid),
                                ),
                                (snapshot.data.hasNextPage)
                                    ? Align(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: cardBg,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                ),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                  ),
                                                  onTap: () {
                                                    if (_pageIndex != 1 &&
                                                        _pageIndex > 1) {
                                                      _pageIndex--;

                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 9),
                                                    decoration: BoxDecoration(
                                                        // color: tkLightGreen,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                    )),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .arrow_back_ios_new_rounded,
                                                          color: _pageIndex == 1
                                                              ? Colors.white
                                                                  .withOpacity(
                                                                      0.4)
                                                              : Colors.white,
                                                        ),
                                                        Text(
                                                          'Prev',
                                                          style: TextStyle(
                                                            color: _pageIndex ==
                                                                    1
                                                                ? Colors.white
                                                                    .withOpacity(
                                                                        0.4)
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(18),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Text(
                                                    _pageIndex.toString(),
                                                    style: kTitleTextStyle
                                                        .copyWith(
                                                            color:
                                                                Colors.black)),
                                              ),
                                              Material(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                ),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                  ),
                                                  onTap: () {
                                                    if (!hasNoMoreResult) {
                                                      _pageIndex++;

                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 9),
                                                    decoration: BoxDecoration(
                                                        // color: tkLightGreen,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    )),
                                                    child: Row(
                                                      children: const [
                                                        Text('Next'),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : (_pageIndex == 1)
                                        ? SizedBox()
                                        : Align(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: cardBg,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                // ignore: prefer_const_literals_to_create_immutables
                                                children: [
                                                  Material(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                    ),
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(20),
                                                      ),
                                                      onTap: () {
                                                        if (_pageIndex != 1 &&
                                                            _pageIndex > 1) {
                                                          _pageIndex--;

                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 9),
                                                        decoration:
                                                            BoxDecoration(
                                                                // color: tkLightGreen,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                        )),
                                                        child: Row(
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .arrow_back_ios_new_rounded,
                                                            ),
                                                            Text('Prev'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(18),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                    child: Text(
                                                        _pageIndex.toString(),
                                                        style: kTitleTextStyle
                                                            .copyWith(
                                                                color: Colors
                                                                    .black)),
                                                  ),
                                                  Material(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 9),
                                                      decoration: BoxDecoration(
                                                          // color: tkLightGreen,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(20),
                                                      )),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Next',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.4)),
                                                          ),
                                                          Icon(
                                                              Icons
                                                                  .arrow_forward_ios_rounded,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.4)),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text(
                              "No Results Found !",
                              style: kSubtitleTextStyle.copyWith(
                                  color: Colors.grey),
                            ),
                          );
                  } else {
                    return Center(
                      child: Text(
                        "No Results Found !",
                        style: kSubtitleTextStyle.copyWith(color: Colors.white),
                      ),
                    );
                  }
                },
              )
            : FutureBuilder<List<String>>(
                future: _getRecentSearches(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(child: Text(""));
                  if (snapshot.hasError) return Text("");
                  if (snapshot.hasData)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              key: Key(index.toString()),
                              title: Text(
                                snapshot.data[index],
                                style: kSubtitleDetailStyle,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  _deleteSearch(snapshot.data[index]);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: kSubtitleColor,
                                ),
                              ),
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  title.value = snapshot.data[index];
                                  _searchController.text = title.value;
                                  _pageIndex = 1;

                                  result = ApiService()
                                      .search(title.value, _pageIndex);

                                  hasValue.value = true;
                                });
                              },
                            );
                          }),
                    );
                  return Center(
                    child: Text(
                      "You Haven't Searched Yet !",
                      style: kSubtitleTextStyle,
                    ),
                  );
                },
              );
      }),
    );
  }

  Future<void> _saveToRecentSearches(searchText) async {
    if (searchText != null) {
      final pref = await SharedPreferences.getInstance();
      Set<String> allSearches =
          pref.getStringList('recentSearches')?.toSet() ?? {};

      allSearches = {searchText, ...allSearches};
      await pref.setStringList('recentSearches', allSearches.toList());
    }
  }

  Future<List<String>> _getRecentSearches() async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList('recentSearches');
    if (allSearches != null) {
      return allSearches.toList();
    }
    return [];
  }

  Future<void> _deleteSearch(searchText) async {
    final pref = await SharedPreferences.getInstance();
    final newList = pref
        .getStringList('recentSearches')!
        .where((result) => result != searchText)
        .toList();
    await pref.setStringList('recentSearches', newList);
  }
}
