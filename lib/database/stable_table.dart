import 'package:sqflite/sqflite.dart';

class StablesTable {
  static const tableName = 'stables';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        display_name TEXT NOT NULL,
        x_name TEXT,
        x_studio_user_id INTEGER,
        x_studio_user_name TEXT,
        x_studio_image TEXT
      )
    ''');
  }

  // Insertar o actualizar un establo
  static Future<int> insertStable(Database db, Map<String, dynamic> stable) async {
    return await db.insert(
      tableName,
      stable,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los establos
  static Future<List<Map<String, dynamic>>> getStables(Database db) async {
    return await db.query(tableName);
  }

  // ✅ Borrar todos los establos
  static Future<void> clear(Database db) async {
    await db.delete(tableName);
  }
}
