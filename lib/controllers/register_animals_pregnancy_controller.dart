import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

class AnimalPregnancyController {
  final AnimalService _animalService = AnimalService();

  Future<bool> saveAnimalPregnancy(int animalId, String inseminationDate, String pregnancyStatus, String expectedBirthDate) async {
    try {
      return await _animalService.saveAnimalPregnancy(animalId, inseminationDate, pregnancyStatus, expectedBirthDate);
    } catch (e) {
      debugPrint('Error al guardar el embarazo del animal: $e');
      return false;
    }
  }
}
