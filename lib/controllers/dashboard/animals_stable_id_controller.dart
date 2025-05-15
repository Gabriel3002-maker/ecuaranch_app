import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

import '../../settings/settings.dart';

class AnimalsStableIdController extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  List<Map<String, dynamic>> animals = [];
  final OdooService odooService = OdooService();

  String db = Config.databaseName;
  String userId = Config.userId.toString();
  String password = Config.password;



  Future<void> fetchAnimals({
    required int stableId, required String db, required int userId, required String password,
  }) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {

      animals = await odooService.getAnimalsByStableIdFromOdoo(
        db: Config.databaseName,
        userId: Config.userId,
        password: Config.password,
        stableId: stableId,
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
