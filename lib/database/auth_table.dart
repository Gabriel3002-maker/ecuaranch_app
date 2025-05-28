import 'package:sqflite/sqflite.dart';

class AuthTable {
  static const tableName = 'auth';

  // Crear tabla con id como PRIMARY KEY (sin AUTOINCREMENT)
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // Insertar o actualizar un usuario
  static Future<int> insertUser(Database db, Map<String, dynamic> user) async {
    return await db.insert(
      tableName,
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los usuarios
  static Future<List<Map<String, dynamic>>> getUsers(Database db) async {
    return await db.query(tableName);
  }

  // Obtener usuario por username
  static Future<Map<String, dynamic>?> getUserByUsername(
      Database db, String username) async {
    final result = await db.query(
      tableName,
      where: 'username = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Eliminar usuario por id
  static Future<int> deleteUser(Database db, int id) async {
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
