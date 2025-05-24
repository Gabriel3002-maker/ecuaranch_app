import 'dart:convert';
import 'dart:ffi';
import 'package:ecuaranch/dto/animalCreateDTO.dart';
import 'package:ecuaranch/dto/animalCreateFeedingDTO.dart';
import 'package:ecuaranch/dto/animalCreateGrowthWeightDTO.dart';
import 'package:ecuaranch/dto/animalCreateHealthMonitoringDTO.dart';
import 'package:ecuaranch/dto/animalCreateObservationDTO.dart';
import 'package:ecuaranch/dto/animalCreateProductionDTO.dart';
import 'package:ecuaranch/dto/animalCreateReproductionFollowUpDTO.dart';
import 'package:ecuaranch/model/create_stable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/partner.dart';
import '../model/person.dart';
import '../settings/settings.dart';

class OdooService {
  final String url = "https://ecuaranch-backend.duckdns.org";

  Future<Map<String, dynamic>> getUserFromOdoo(String db, String username,
      String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_user_from_odoo"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }


  Future<List<Map<String, dynamic>>> getStablesFromOdoo(String db,
      String userId, String password,
      {int offset = 0, int limit = 10}) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_stables_from_odoo"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
          "offset": offset,
          "limit": limit,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['status'] == 'success') {
          final List<dynamic> stablesData = responseBody['animals'];
          return List<Map<String, dynamic>>.from(stablesData);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAnimalsByStableIdFromOdoo({
    required String db,
    required int userId,
    required String password,
    required int stableId,
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/get_animals_by_stable_id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'db': db,
          'user_id': userId,
          'password': password,
          'stable_id': stableId,
          'offset': offset,
          'limit': limit,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['status'] == 'success') {
          final List<dynamic> animalsData = responseBody['animals'];
          return List<Map<String, dynamic>>.from(animalsData);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception(
            'Error al obtener datos del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }


  Future<Map<String, dynamic>> getAnimalDetailsById({
    required String db,
    required int userId,
    required String password,
    required int animalId,
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/get_information_animal_id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'db': db,
          'user_id': userId,
          'password': password,
          'animal_id': animalId,
          'offset': offset,
          'limit': limit,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          return responseBody['animals'][0];
        } else {
          throw Exception('Error en la respuesta del servidor');
        }
      } else {
        throw Exception('Error al obtener los detalles del animal');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }


  Future<List<Map<String, dynamic>>> getAnimalsFromOdoo(String db,
      String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_animals_from_odoo"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Extraer la lista de 'stables' de la respuesta
        if (responseBody['status'] == 'success') {
          final List<
              dynamic> stablesData = responseBody['animals']; // Aquí obtenemos los estables
          // Retornamos la lista de estables como una lista de Map<String, dynamic>
          return List<Map<String, dynamic>>.from(stablesData);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<Map<String, dynamic>> fetchAnimalHistoryObservation({
    required String db,
    required int userId,
    required String password,
    required int animalId,
    int offset = 0,
    int limit = 10,
  }) async {
    final response = await http.post(
      Uri.parse('$url/get_information_animal_id_observation'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'db': db,
        'user_id': userId,
        'password': password,
        'animal_id': animalId,
        'offset': offset,
        'limit': limit,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded;
    } else {
      throw Exception('Error al cargar el histórico del animal - Observation');
    }
  }


  Future<Map<String, dynamic>> fetchAnimalHistoryHealth({
    required String db,
    required int userId,
    required String password,
    required int animalId,
    int offset = 0,
    int limit = 10,
  }) async {
    final response = await http.post(
      Uri.parse('$url/get_information_animal_id_health'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'db': db,
        'user_id': userId,
        'password': password,
        'animal_id': animalId,
        'offset': offset,
        'limit': limit,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Error al cargar el histórico del animal - Health');
    }
  }

  Future<Map<String, dynamic>> fetchAnimalHistoryGrow({
    required String db,
    required int userId,
    required String password,
    required int animalId,
    int offset = 0,
    int limit = 10,
  }) async {
    final response = await http.post(
      Uri.parse('$url/get_information_animal_id_grow'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'db': db,
        'user_id': userId,
        'password': password,
        'animal_id': animalId,
        'offset': offset,
        'limit': limit,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Error al cargar el histórico del animal - Grow');
    }
  }

  Future<Map<String, dynamic>> fetchAnimalHistoryReproductionFollow({
    required String db,
    required int userId,
    required String password,
    required int animalId,
    int offset = 0,
    int limit = 10,
  }) async {
    final response = await http.post(
      Uri.parse('$url/get_information_animal_id_reproductionFollow'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'db': db,
        'user_id': userId,
        'password': password,
        'animal_id': animalId,
        'offset': offset,
        'limit': limit,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception(
          'Error al cargar el histórico del animal - Reproduction Follow');
    }
  }

  Future<Map<String, dynamic>> fetchAnimalHistoryFeeding({
    required String db,
    required int userId,
    required String password,
    required int animalId,
    int offset = 0,
    int limit = 10,
  }) async {
    final response = await http.post(
      Uri.parse('$url/get_information_animal_id_feeding'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'db': db,
        'user_id': userId,
        'password': password,
        'animal_id': animalId,
        'offset': offset,
        'limit': limit,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Error al cargar el histórico del animal - Feeding');
    }
  }


  Future<Map<String, dynamic>> fetchAnimalHistoryProduction({
    required String db,
    required int userId,
    required String password,
    required int animalId,
    int offset = 0,
    int limit = 10,
  }) async {
    final response = await http.post(
      Uri.parse('$url/get_information_animal_id_reproduction'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'db': db,
        'user_id': userId,
        'password': password,
        'animal_id': animalId,
        'offset': offset,
        'limit': limit,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Error al cargar el histórico del animal - Reproduction');
    }
  }


  Future<Map<String, dynamic>> createAnimal(AnimalDto animalDto) async {
    try {
      final response = await http.post(
        Uri.parse("$url/create_animal_in_odoo"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(animalDto.toJson()),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<Map<String, dynamic>> createObservationinAnimal(
      AnimalObservationDTO animalObservationDto) async {
    try {
      final response = await http.post(
        Uri.parse("$url/create_observation_in_animal_odoo"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(animalObservationDto.toJson()),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<Map<String, dynamic>> createHealthMonitoringAnimal(
      HealthMonitoringAnimalDTO animalHealthMonitoringDto) async {
    try {
      final response = await http.post(
        Uri.parse("$url/health_monitoring_animal_in_odoo"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(animalHealthMonitoringDto.toJson()),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<Map<String, dynamic>> createGrowthWeightAnimal(
      CreateGrowthWeightAnimalDTO animalGrowthWeightDto) async {
    try {
      final response = await http.post(
        Uri.parse("$url/create_growthweight_animal_in_odoo"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(animalGrowthWeightDto.toJson()),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<Map<String, dynamic>> createReproductionFollowupAnimal(
      CreateReproductionFollowUpDTO animalReproductionFollowUpDto) async {
    try {
      final response = await http.post(
        Uri.parse("$url/create_reproduction_followup_animal_in_odoo"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(animalReproductionFollowUpDto.toJson()),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<Map<String, dynamic>> createFeedingAnimal(
      FeedingDTOAnimal animalFeedingDto) async {
    try {
      final response = await http.post(
        Uri.parse("$url/create_feeding_animal_line"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(animalFeedingDto.toJson()),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<Map<String, dynamic>> createProductionAnimal(
      ProductionDTO animalProductionDto) async {
    try {
      final response = await http.post(
        Uri.parse("$url/create_production"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(animalProductionDto.toJson()),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }


  Future<List<Map<String, dynamic>>> getEventsFromOdoo(String db, String userId,
      String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_events"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // ✅ Solución: forzar decodificación UTF-8
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          final List<dynamic> eventsData = responseBody['events'];
          return List<Map<String, dynamic>>.from(eventsData);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getLeadsFromOdoo(String db, String userId,
      String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_crm"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // ✅ Solución: forzar decodificación UTF-8
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          final List<dynamic> eventsData = responseBody['leads'];
          return List<Map<String, dynamic>>.from(eventsData);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getExpensesFromOdoo(String db,
      String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_expenses"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // ✅ Solución: forzar decodificación UTF-8
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          final List<dynamic> eventsData = responseBody['expenses'];
          return List<Map<String, dynamic>>.from(eventsData);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getFactoryFromOdoo(String db,
      String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_factory"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // ✅ Solución: forzar decodificación UTF-8
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          final List<dynamic> eventsData = responseBody['factory'];
          return List<Map<String, dynamic>>.from(eventsData);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getSalesFromOdoo(String db, String userId,
      String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_sales"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // ✅ Solución: forzar decodificación UTF-8
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          final List<dynamic> eventsData = responseBody['factory'];
          return List<Map<String, dynamic>>.from(eventsData);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getWarehouseFromOdoo(String db,
      String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_Warehouses"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // ✅ Solución: forzar decodificación UTF-8
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          final List<dynamic> eventsData = responseBody['warehouses'];
          return List<Map<String, dynamic>>.from(eventsData);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  static Future<bool> createStable(StableData data) async {
    final url = Uri.parse(
        "https://ecuaranch-backend.duckdns.org/create_stable");

    final headers = {"Content-Type": "application/json"};

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data.toJson()),
    );

    return response.statusCode == 200;
  }

  static Future<List<Person>> fetchPersons() async {
    final url = Uri.parse('https://ecuaranch-backend.duckdns.org/get_person');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "db": Config.databaseName,
        "user_id": Config.userId,
        "password": Config.password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> personList = jsonData['person'];
      return personList.map((json) => Person.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener personas');
    }
  }

  static Future<Map<String, dynamic>> createPerson(Partner partner) async {
    final url = Uri.parse("https://ecuaranch-backend.duckdns.org/create_person");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(partner.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al registrar la persona');
    }
  }


  Future<Map<String, dynamic>> getMonthlySalesAndExpenses(String db,
      String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_monthly_sales_and_expenses"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          // Devuelve solo los datos relevantes
          return {
            "total_sales": responseBody["total_sales"],
            "total_expenses": responseBody["total_expenses"],
            "net_profit": responseBody["net_profit"],
          };
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAnimalsHealthAlerts(String db,
      String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_animals_health_alerts"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // ✅ Solución: forzar decodificación UTF-8
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          final List<dynamic> eventsData = responseBody['health'];
          return List<Map<String, dynamic>>.from(eventsData);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAnimalsWeightAlerts(String db,
      String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_animals_weight_alerts"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // ✅ Solución: forzar decodificación UTF-8
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          final List<dynamic> eventsData = responseBody['health'];
          return List<Map<String, dynamic>>.from(eventsData);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  Future<Map<String, dynamic>> getAnimalsByGenero(String genero) async {
    final url = 'https://ecuaranch-backend.duckdns.org/get_nro_animals'; // API URL

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // Create the body with db, user_id, password, and genero
    final body = json.encode({
      'db': 'ecuaRancht1',
      'user_id': 2,
      'password': 'gabriel@nextgensolutions.group',
      'genero': genero, // Include genero in the body
    });

    try {
      // Send the POST request with the URL, headers, and body
      final response = await http.post(
        Uri.parse('$url?genero=$genero'),  // Add genero as a query parameter
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load animals');
      }
    } catch (e) {
      throw Exception('Error fetching data from API: $e');
    }
  }

  Future<void> updateHealthAlerts(
      String db,
      String userId,
      String password,
      int alertId,
      ) async {
    try {
      final response = await http.post(
        Uri.parse("$url/deactivate_health_alert"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
          "alert_id": alertId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          final message = responseBody['message'] ?? 'Alerta desactivada correctamente';
          debugPrint(message);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }


  Future<void> updateWeightAlerts(
      String db,
      String userId,
      String password,
      int alertId,
      ) async {
    try {
      final response = await http.post(
        Uri.parse("$url/deactivate_weight_alert"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id": int.tryParse(userId) ?? 0,
          "password": password,
          "alert_id": alertId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          final message = responseBody['message'] ?? 'Alerta desactivada correctamente';
          debugPrint(message);
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }







}



