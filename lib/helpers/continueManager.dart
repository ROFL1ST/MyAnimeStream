import 'dart:developer';

import 'package:get/get.dart';

import '../API/storage/continue_database.dart';
import '../API/model/continueWatch.dart';

class ContinueManager extends GetxController {
  List<ContinueWatch> _list = [];
  List<String> _idList = [];

  List<ContinueWatch> get continueList => [..._list.reversed];
  List<String> get ids => [..._idList];

  Future<void> loadContinueFromDatabase() async {
    final result = await ContinueDatabase.instance.getAllContinue();
    if (result != null) {
      _list = result;
      for (var continues in _list) {
        _idList.add(continues.id);
      }
    } else {
      _list = [];
      _idList = [];
    }
  }

  void addContinue(ContinueWatch anime) async {
    for (var rm in _list) {
      if (rm.id == anime.id) {
        ContinueDatabase.instance.remove(anime.id);
      }
    }

    _list.removeWhere((element) => (element.id == anime.id));
    _idList.removeWhere((element) => (element == anime.id));

    _list.add(anime);
    _idList.add(anime.id);

    await ContinueDatabase.instance.add(anime);
    return update();
  }

  void removeContinue(String id) {
    _list.removeWhere((element) => (element.id == id));
    _idList.removeWhere((element) => (element == id));

    ContinueDatabase.instance.remove(id);
    return update();
  }

  void removeAllContinue() {
    _list.clear();
    _idList.clear();
    ContinueDatabase.instance.removeAll();
    return update();
  }
}
