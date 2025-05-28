import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../database/auth_table.dart';

class AuthService {
  final Database db;

  AuthService(this.db);

  Future<int?> loginAndSave(String username, String password) async {
    final url = Uri.parse('https://ecuaranch-backend.duckdns.org/get_user_from_odoo');

    final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'db': 'ecuaRanch',
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final userId = data['user_id'];

        await AuthTable.insertUser(db, {
          'id': userId,
          'username': username,
          'password': password,
        });

        return userId;
      } else {
        throw Exception('Login failed: ${data['status']}');
      }
    } else {
      throw Exception('Error en login');
    }
  }

  Future<Map<String, dynamic>?> getLocalUser(String username) async {
    return await AuthTable.getUserByUsername(db, username);
  }
}
