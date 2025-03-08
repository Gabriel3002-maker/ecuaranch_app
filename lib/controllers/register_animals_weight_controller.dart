import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

class AnimalWeightController {
  final AnimalService _animalService = AnimalService();

  Future<bool> saveAnimalWeight(int animalId, String date, double weight) async {
    try {
      return await _animalService.saveAnimalWeight(animalId, date, weight);
    } catch (e) {
      debugPrint('Error al guardar el peso del animal: $e');
      return false;
    }
  }
}
