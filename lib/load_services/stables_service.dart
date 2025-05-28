import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../database/stable_table.dart';

class StablesService {
  final Database db;
  final int userId;
  final String password;

  StablesService(this.db, this.userId, this.password);

  Future<void> syncStables({int offset = 0, int limit = 10}) async {
    final url = Uri.parse('https://ecuaranch-backend.duckdns.org/get_stables_from_odoo');

    final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'db': 'ecuaRanch',
        'user_id': userId,
        'password': password,
        'offset': offset,
        'limit': limit,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final List stables = data['animals'];

        for (final stable in stables) {
          int? studioUserId;
          String? studioUserName;

          if (stable['x_studio_user_id'] != null && stable['x_studio_user_id'] is List) {
            studioUserId = stable['x_studio_user_id'][0];
            studioUserName = stable['x_studio_user_id'][1];
          }

          await StablesTable.insertStable(db, {
            'id': stable['id'],
            'display_name': stable['display_name'],
            'x_name': stable['x_name'],
            'x_studio_user_id': studioUserId,
            'x_studio_user_name': studioUserName,
            'x_studio_image': stable['x_studio_image']?.toString(),
          });
        }
      } else {
        throw Exception('Error sync stables: ${data['status']}');
      }
    } else {
      throw Exception('Error al sincronizar stables');
    }
  }

  Future<List<Map<String, dynamic>>> getLocalStables() async {
    return await StablesTable.getStables(db);
  }
}
