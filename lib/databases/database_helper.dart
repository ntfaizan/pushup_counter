import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        "CREATE TABLE IF NOT EXISTS push_ups(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, counter INTEGER)");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'mypushup.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item
  static Future<int> saveItem(int? count) async {
    final db = await DatabaseHelper.db();
    final data = {'counter': count};
    final id = await db.insert('push_ups', data);
    return id;
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.rawQuery('SELECT * FROM push_ups');
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }
}
