import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_anime_stream/API/model/continueWatch.dart';
import 'package:my_anime_stream/API/storage/continue_database.dart';

import '../API/storage/history_database.dart';
import '../API/model/recent_anime.dart';
import "continueManager.dart";

class HistoryManager extends GetxController {
  final ContinueManager continueManager = Get.put(ContinueManager());

  List<RecentAnime> _recentAnimes = [];
  List<String> _epsIdList = [];
  List<RecentAnime> get animeList => [..._recentAnimes.reversed];
  List<String> get epsIdList => [..._epsIdList];

  Future<void> loadHistoryFromDatabase() async {
    final result = await HistoryDatabase.instance.getAllHistoryAnime();
    if (result != null) {
      _recentAnimes = result;

      for (var history in _recentAnimes) {
        _epsIdList.add(history.episodeId);
      }
    }
  }

  void addHistoryAnime(RecentAnime anime) async {
    DateTime now = DateTime.now();

    final cons = ContinueWatch(
        id: anime.id,
        episodeId: anime.episodeId,
        currentEp: anime.currentEp,
        title: anime.title,
        image: anime.image,
        createAt: now.toString(),
        type: anime.type, imageEps: anime.imageEps);
    for (var rm in _recentAnimes) {
      if (rm.episodeId == anime.episodeId) {
        HistoryDatabase.instance.remove(anime.episodeId);
      }
    }
    if (continueManager.ids.contains(anime.id)) {
      continueManager.removeContinue(anime.id);
      continueManager.addContinue(cons);
      log("$cons");
    } else {
      continueManager.addContinue(cons);
    }
    _recentAnimes
        .removeWhere((element) => (element.episodeId == anime.episodeId));
    _epsIdList.removeWhere((element) => (element == anime.episodeId));
    _recentAnimes.add(anime);
    _epsIdList.add(anime.episodeId);

    await HistoryDatabase.instance.add(anime);
    return update();
  }

  void removeHistory(String episodeId) {
    _recentAnimes.removeWhere((element) => element.episodeId == episodeId);
    _epsIdList.removeWhere((element) => (element == episodeId));

    HistoryDatabase.instance.remove(episodeId);
    return update();
  }

  void removeAllHistory() {
    _recentAnimes.clear();
    _epsIdList.clear();
    HistoryDatabase.instance.removeAll();
    return update();
  }

  void closeDb() {
    _recentAnimes.clear();
    HistoryDatabase.instance.close();
    return update();
  }
}
