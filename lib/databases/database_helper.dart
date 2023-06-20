import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<sql.Database> openDb() async {
    return sql.openDatabase(
      'mypushup.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await database.execute(
            "CREATE TABLE IF NOT EXISTS push_ups(id INTEGER PRIMARY KEY AUTOINCREMENT, count INTEGER)");
      },
    );
  }

  // Create new item
  static Future<int> saveCounter(int countValue) async {
    final db = await DatabaseHelper.openDb();
    final id = await db.insert('push_ups', {'count': countValue});
    return id;
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getCounters() async {
    final db = await DatabaseHelper.openDb();
    return db.rawQuery('SELECT * FROM push_ups');
  }

  static Future<int> updateCounter(int id, int countValue) async {
    final db = await DatabaseHelper.openDb();
    final result = await db.rawUpdate(
        'UPDATE push_ups SET count = ? WHERE id = ?', [countValue, id]);
    // final result = await db.update('push_ups', {'count': countValue},
    //     where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.openDb();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }
}
