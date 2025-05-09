import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

import '../../../settings/settings.dart';

class AnimalHistoryReproductionController extends ChangeNotifier {
  final OdooService odooService = OdooService();

  bool isLoading = false;
  String errorMessage = '';
  List<dynamic> animalHistoryReproduction = [];


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
      final data = await odooService.fetchAnimalHistoryReproductionFollow(
        db: Config.databaseName,
        userId: Config.userId,
        password: Config.password,
        animalId: animalId,
        offset: offset,
        limit: limit,
      );
      animalHistoryReproduction = data['animals'] ?? [];
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}