import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:favorite_places/core/constants/app_constants.dart';

class PlacesLocalDatasource {
  static Database? _db;

  static Future<Database> get _database async {
    if (_db != null) return _db!;
    final dbPath = await sql.getDatabasesPath();
    _db = await sql.openDatabase(
      path.join(dbPath, AppConstants.dbName),
      version: AppConstants.dbVersion,
      onCreate: (db, _) => db.execute(
        'CREATE TABLE ${AppConstants.dbTable}('
        'id TEXT PRIMARY KEY, title TEXT, image TEXT, '
        'lat REAL, lng REAL, address TEXT)',
      ),
    );
    return _db!;
  }

  static Future<List<Map<String, dynamic>>> fetchAll() async {
    final db = await _database;
    return db.query(AppConstants.dbTable);
  }

  static Future<void> insert(Map<String, dynamic> row) async {
    final db = await _database;
    await db.insert(AppConstants.dbTable, row);
  }

  static Future<void> delete(String id) async {
    final db = await _database;
    await db.delete(AppConstants.dbTable,
        where: 'id = ?', whereArgs: [id]);
  }
}
