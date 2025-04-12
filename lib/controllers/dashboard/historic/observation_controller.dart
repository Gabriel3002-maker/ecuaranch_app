import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

class AnimalHistoryObservationController extends ChangeNotifier {
  final OdooService odooService = OdooService();

  bool isLoading = false;
  String errorMessage = '';
  List<dynamic> animalHistoryObservation = [];


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
      final data = await odooService.fetchAnimalHistoryObservation(
        db: 'ecuaRanch',
        userId: 2,
        password: 'gabriel@nextgensolutions.group',
        animalId: animalId,
        offset: offset,
        limit: limit,
      );
      animalHistoryObservation = data['animals'] ?? [];
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
