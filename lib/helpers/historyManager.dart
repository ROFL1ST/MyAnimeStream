import 'package:get/get.dart';

import '../API/storage/history_database.dart';
import '../API/model/recent_anime.dart';

class HistoryManager extends GetxController {
  List<RecentAnime> _recentAnimes = [];
  List<RecentAnime> get animeList => [..._recentAnimes.reversed];

  Future<void> loadHistoryFromDatabase() async {
    final result = await HistoryDatabase.instance.getAllHistoryAnime();
    if (result != null) {
      _recentAnimes = result;
    }
  }

  void addHistoryAnime(RecentAnime anime) {
    for (var rm in _recentAnimes) {
      if (rm.id == anime.id) {
        HistoryDatabase.instance.remove(anime.id);
      }
    }
    _recentAnimes.removeWhere((element) => (element.id == anime.id));
    _recentAnimes.add(anime);
    HistoryDatabase.instance.add(anime);
    update();
  }

  void removeHistory(String id) {
    _recentAnimes.removeWhere((element) => element.id == id);
    HistoryDatabase.instance.remove(id);
    update();
  }

  void removeAllHistory() {
    _recentAnimes.clear();
    HistoryDatabase.instance.removeAll();
    update();
  }
}
