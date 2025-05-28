import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../database/events_table.dart';

class EventsService {
  final Database db;
  final int userId;
  final String password;

  EventsService(this.db, this.userId, this.password);

  Future<void> syncEvents() async {
    final url = Uri.parse('https://ecuaranch-backend.duckdns.org/get_events');

    final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'db': 'ecuaRanch',
        'user_id': userId,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final List events = data['events'];

        for (final event in events) {
          await EventsTable.insertEvent(db, {
            'id': event['id'],
            'name': event['name'],
            'description': event['description'],
            'date_begin': event['date_begin'],
            'date_end': event['date_end'],
            'address_inline': event['address_inline'],
          });
        }
      } else {
        throw Exception('Error sync events: ${data['status']}');
      }
    } else {
      throw Exception('Error al sincronizar eventos');
    }
  }

  Future<List<Map<String, dynamic>>> getLocalEvents() async {
    return await EventsTable.getEvents(db);
  }
}
