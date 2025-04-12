import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

class AnimalHistoryGrowController extends ChangeNotifier {
  final OdooService odooService = OdooService();

  bool isLoading = false;
  String errorMessage = '';
  List<dynamic> animalHistoryGrow = [];


  Future<void> fetchAnimalHistory({
    required String db,
    required int userId,
    required String password,
    required int animalId,
    int offset = 0,
    int limit = 10,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await odooService.fetchAnimalHistoryGrow(
        db: 'ecuaRanch',
        userId: 2,
        password: 'gabriel@nextgensolutions.group',
        animalId: animalId,
        offset: offset,
        limit: limit,
      );
      animalHistoryGrow = data['animals'] ?? [];
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}