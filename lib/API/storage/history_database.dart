import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/recent_anime.dart';

class HistoryDatabase {
  HistoryDatabase._privateConstructor();

  static final HistoryDatabase instance = HistoryDatabase._privateConstructor();
  static Database? _database;

  final String tableHistory = "History";
  final String idCol = "id";
  final String epsIdCol = "epsId";
  final String titleCol = "title";
  final String epUrlCol = "epUrl";
  final String currentEpCol = "currentEp";
  final String imageCol = "image";

  final String type = 'TEXT NOT NULL';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, tableHistory);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database db, version) async {
    await db.execute('''
    CREATE TABLE $tableHistory (
      $idCol $type,$epsIdCol $type, $titleCol $type, $epUrlCol $type, $currentEpCol $type, $imageCol $type)
    ''');
  }

  Future<List<RecentAnime>>? getAllHistoryAnime() async {
    final db = await instance.database;
    final result = await db.query(tableHistory);
    return result.map((e) => RecentAnime.fromJson(e)).toList();
  }

  Future<void> add(RecentAnime anime) async {
    final db = await instance.database;
    final result = await db.insert(
      tableHistory,
      anime.toJson(),
    );
    if (result != -1) {
      // ignore: avoid_print
      print('success');
    }
  }

  Future<int> remove(String id) async {
    final db = await instance.database;
    return await db.delete(
      tableHistory,
      where: '$idCol == ?',
      whereArgs: [id],
    );
  }

  Future<int> removeAll() async {
    final db = await instance.database;
    return await db.delete(
      tableHistory,
    );
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
