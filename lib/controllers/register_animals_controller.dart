import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

class RegisterAnimalsController {
  final AnimalService _animalService = AnimalService();

  Future<bool> createAnimal(String name, String specie) async {
    try {
      return await _animalService.saveAnimal(name, specie);
    } catch (e) {
      debugPrint('Error al crear el animal: $e');
      return false;
    }
  }
}
