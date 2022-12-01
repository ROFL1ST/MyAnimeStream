import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/continueWatch.dart';

class ContinueDatabase {
  ContinueDatabase._privateConstructor();

  static final ContinueDatabase instance =
      ContinueDatabase._privateConstructor();

  static Database? _database;

  final String tableContinue = "Continue";
  final String idCol = "id";
  final String episodeIdCol = "episodeId";
  final String titleCol = "title";
  final String typeCol = "type";

  final String currentEpCol = "currentEp";

  final String imageCol = "image";
  final String imageEpsCol = "imageEps";

  final String createAtCol = "createAt";

  final String type = 'TEXT NOT NULL';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, tableContinue);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database database, version) async {
    await database.execute('''
    CREATE TABLE $tableContinue (
      $idCol $type,$episodeIdCol $type, $titleCol $type, $typeCol $type, $currentEpCol $type, $imageCol $type, $imageEpsCol $type, $createAtCol $type)
    ''');
  }

  Future<List<ContinueWatch>>? getAllContinue() async {
    final db = await instance.database;
    final result = await db.query(tableContinue);
    return result.map((e) => ContinueWatch.fromJson(e)).toList();
  }

  Future<void> add(ContinueWatch anime) async {
    final db = await instance.database;
    final result = await db.insert(
      tableContinue,
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
      tableContinue,
      where: '$idCol == ?',
      whereArgs: [id],
    );
  }

  Future<int> removeAll() async {
    final db = await instance.database;
    return await db.delete(
      tableContinue,
    );
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
