import 'package:sqflite/sqflite.dart';

class EventsTable {
  static const tableName = 'events';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        date_begin TEXT,
        date_end TEXT,
        address_inline TEXT
      )
    ''');
  }

  // Insertar o actualizar evento
  static Future<int> insertEvent(Database db, Map<String, dynamic> event) async {
    return await db.insert(
      tableName,
      event,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los eventos
  static Future<List<Map<String, dynamic>>> getEvents(Database db) async {
    return await db.query(tableName, orderBy: 'date_begin DESC');
  }

  // Obtener evento por id
  static Future<Map<String, dynamic>?> getEventById(Database db, int id) async {
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Eliminar evento por id
  static Future<int> deleteEvent(Database db, int id) async {
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
