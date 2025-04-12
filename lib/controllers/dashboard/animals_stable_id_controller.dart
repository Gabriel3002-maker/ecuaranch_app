import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

class AnimalsStableIdController extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  List<Map<String, dynamic>> animals = [];
  final OdooService odooService = OdooService();


  Future<void> fetchAnimals({
    required String db,
    required int userId,
    required String password,
    required int stableId,
  }) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      
      animals = await odooService.getAnimalsByStableIdFromOdoo(
        db: db,
        userId: userId,
        password: password,
        stableId: stableId,
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
