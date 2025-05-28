import 'package:ecuaranch/database/events_table.dart';
import 'package:ecuaranch/database/stable_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'auth_table.dart';


class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('offline_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await AuthTable.createTable(db);
    await StablesTable.createTable(db);
    await EventsTable.createTable(db);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
