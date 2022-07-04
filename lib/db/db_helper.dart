import 'package:note_3/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as devtools show log;

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        devtools.log('Creating a new one');
        return db.execute(
          "CREATE TABLE $_tableName("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "title STRING, note TEXT, date STRING, "
          "startTime STRING, endTime STRING, "
          "remind INTEGER, repeat INTEGER, "
          "color INTEGER, "
          "isCompleted INTEGER)",
        );
      });
    } catch (e) {
      devtools.log('Error found $e');
    }
  }

  static Future<int> insert(Task? task) async {
    devtools.log('Insert function called');
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    devtools.log('Query function called');
    return await _db!.query(_tableName);
  }
}
