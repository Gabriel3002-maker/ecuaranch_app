import 'dart:convert';
import 'package:ecuaranch/dto/animalCreateDTO.dart';
import 'package:ecuaranch/dto/animalCreateFeedingDTO.dart';
import 'package:ecuaranch/dto/animalCreateGrowthWeightDTO.dart';
import 'package:ecuaranch/dto/animalCreateHealthMonitoringDTO.dart';
import 'package:ecuaranch/dto/animalCreateObservationDTO.dart';
import 'package:ecuaranch/dto/animalCreateProductionDTO.dart';
import 'package:ecuaranch/dto/animalCreateReproductionFollowUpDTO.dart';
import 'package:http/http.dart' as http;

class OdooService {
  final String url = "https://ecuaranch-backend.duckdns.org";

  Future<Map<String, dynamic>> getUserFromOdoo(
      String db, String username, String password) async {
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


  Future<List<Map<String, dynamic>>> getStablesFromOdoo(
    String db, String userId, String password,
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
        throw Exception('Error en la respuesta del servidor: ${responseBody['status']}');
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
        throw Exception('Error en la respuesta del servidor: ${responseBody['status']}');
      }
    } else {
      throw Exception('Error al obtener datos del servidor: ${response.statusCode}');
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



Future<List<Map<String, dynamic>>> getAnimalsFromOdoo(
      String db, String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_animals_from_odoo"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": db,
          "user_id":  int.tryParse(userId) ?? 0,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Extraer la lista de 'stables' de la respuesta
        if (responseBody['status'] == 'success') {
          final List<dynamic> stablesData = responseBody['animals'];  // Aquí obtenemos los estables
          // Retornamos la lista de estables como una lista de Map<String, dynamic>
          return List<Map<String, dynamic>>.from(stablesData);
        } else {
          throw Exception('Error en la respuesta del servidor: ${responseBody['status']}');
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
      headers: {'Content-Type': 'application/json'},
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
      return jsonDecode(response.body);
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
      headers: {'Content-Type': 'application/json'},
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
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar el histórico del animal - health');
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
      headers: {'Content-Type': 'application/json'},
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
      return jsonDecode(response.body);
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
      headers: {'Content-Type': 'application/json'},
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
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar el histórico del animal - Reproduction Follow');
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
      headers: {'Content-Type': 'application/json'},
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
      return jsonDecode(response.body);
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
      headers: {'Content-Type': 'application/json'},
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
      return jsonDecode(response.body);
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

      if (response.statusCode == 200) {
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
}
