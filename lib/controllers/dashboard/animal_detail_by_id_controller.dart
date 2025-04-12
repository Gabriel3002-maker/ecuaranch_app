import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

class AnimalByIdDetailController extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  Map<String, dynamic> animalDetails = {};

  final OdooService odooService = OdooService();

  Future<void> fetchAnimalDetails({
    required String db,
    required int userId,
    required String password,
    required int animalId,
  }) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      animalDetails = await odooService.getAnimalDetailsById(
        db: 'ecuaRanch',
        userId: 2,
        password: 'gabriel@nextgensolutions.group',
        animalId: animalId,
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
