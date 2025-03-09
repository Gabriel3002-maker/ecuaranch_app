import 'package:ecuaranch/dto/animalDto.dart';
import 'package:ecuaranch/dto/animalPregnaciesDto.dart';
import 'package:ecuaranch/dto/animalWeightDto.dart';
import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

class GetAnimalsController {
  List<AnimalDTO> animals = [];
  List<AnimalDTO> animalsById = [];
  List<AnimalPregnancyDTO> pregnancies = [];
  List<AnimalWeightDTO> weights = [];


  final AnimalService _animalService = AnimalService();

 
  Future<void> getListAnimals() async {
    try {
      animals = await _animalService.getAnimals();
    } catch (e) {
      debugPrint('Error al obtener los animales: $e');
    }
  }

  Future<void> getAnimalsById(int animalId) async {
    try {
      animalsById =  await _animalService.getAnimalsById(animalId);
    } catch (e) {
      debugPrint('Error al obtener los animales by id: $e');
    }
  }

    Future<void> getAnimalPregnanciesById (int animalId) async {
    try {
      pregnancies = await _animalService.getAnimalsByIdPregnancies(animalId);
    } catch (e) {
      debugPrint('Error al obtener los animales pregnacies by id: $e');
    }
  }

    Future<void> getAnimalsWeightById(int animalId) async {
    try {
      weights =  await _animalService.getAnimalsByIdWeight(animalId);
    } catch (e) {
      debugPrint('Error al obtener los animales weight by id: $e');
    }
  }
}
