import 'package:ecuaranch/settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AnimalService {

  Future<bool> saveAnimal(String name, String specie) async {
    final String url = '${Config.baseUrl}/animals?name=$name&specie=$specie';

    try {
      final response = await http.post(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        return true; 
      } else {
        return false; 
      }
    } catch (e) {
      debugPrint('Error al hacer la solicitud: $e');
      return false;
    }
  }

  Future<bool> saveAnimalWeight(int animalId, String date, double weight) async {
    final String url = '${Config.baseUrl}/weights?animal_id=$animalId&date=$date&weight=$weight';

    try {
      final response = await http.post(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        return true;  
      } else {
        return false; 
      }
    } catch (e) {
      debugPrint('Error al hacer la solicitud: $e');
      return false;
    }
  }

  Future<bool> saveAnimalPregnancy(int animalId, String inseminationDate, String pregnancyStatus, String expectedBirthDate) async {
    final String url = '${Config.baseUrl}/pregnancies?animal_id=$animalId&insemination_date=$inseminationDate&pregnancy_status=$pregnancyStatus&expected_birth_date=$expectedBirthDate';

    try {
      final response = await http.post(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        return true; // La solicitud fue exitosa
      } else {
        return false; // La solicitud no fue exitosa
      }
    } catch (e) {
      debugPrint('Error al hacer la solicitud: $e');
      return false;
    }
  }
}
