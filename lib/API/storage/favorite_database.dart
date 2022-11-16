import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/favorite.dart';

class FavoriteDatabase {
  FavoriteDatabase._privateConstructor();

  static final FavoriteDatabase instance =
      FavoriteDatabase._privateConstructor();
  static Database? _database;

  final String tableFavorite = "Favorite";
  final String idCol = "id";
  final String titleCol = "title";
  final String imageCol = "image";
  final String urlCol = "url";

  final dbName = "fav.db";
  final idType = 'TEXT NOT NULL';
  final textType = 'TEXT NOT NULL';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, dbName);

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database db, version) async {
    await db.execute('''
    CREATE TABLE $tableFavorite(
      $idCol $idType, $titleCol $textType, $imageCol $textType, $urlCol $textType)''');
  }

  Future<void> insert(Favorite favorite) async {
    final db = await instance.database;
    final result = await db.insert(tableFavorite, favorite.toJson());
    if (result != -1) {
      // ignore: avoid_print
      print('success');
    }
  }

  Future<List<Favorite>>? getAllFavorite() async {
    final db = await instance.database;
    final results = await db.query(tableFavorite);
    return results.map((e) => Favorite.fromJson(e)).toList();
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return db.delete(
      tableFavorite,
      where: '$idCol == ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
