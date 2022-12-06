import 'dart:developer';

import 'package:get/get.dart';
import "package:flutter/material.dart";
import '../API/storage/favorite_database.dart';
import '../API/model/favorite.dart';

class FavoriteManager extends GetxController {
  List<Favorite> _list = [];
  List<String> _idList = [];
  List<Favorite> get favorites => [..._list];
  List<String> get ids => [..._idList];

  Future<void> loadFavoriteFromDatabase() async {
    final dataList = await FavoriteDatabase.instance.getAllFavorite();
    if (dataList != null) {
      _list = dataList;
      for (var favorite in _list) {
        _idList.add(favorite.id);
      }
    }
  }

  void addToFavorite(Favorite item) async {
    _list.add(item);
    _idList.add(item.id);
    await FavoriteDatabase.instance.insert(item);
    return update();
  }

  void removeFromFavorite(Favorite item) async {
    _list.removeWhere((element) => element.id == item.id);
    _idList.removeWhere((element) => element == item.id);
    await FavoriteDatabase.instance.delete(item.id);
    return update();
  }
}
