import 'package:flutter/material.dart';
import 'package:ecuaranch/services/services.dart';

import '../../settings/settings.dart';

class WeightAlertController extends ChangeNotifier {
  final OdooService odooService = OdooService();
  List<Map<String, dynamic>> weight = [];
  bool isLoading = false;
  String errorMessage = '';

  String db = Config.databaseName;
  String userId = Config.userId.toString();
  String password = Config.password;

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      weight = await odooService.getAnimalsWeightAlerts(
          db,
          userId,
          password
      );
      errorMessage = '';
    } catch (e) {
      errorMessage = e.toString();
      weight = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> takeActionOnAlert(int alertId) async {
    isLoading = true;
    notifyListeners();

    try {
      await odooService.updateWeightAlerts(db, userId, password, alertId);

      errorMessage = 'Alerta desactivada correctamente';
      await fetchUserData();
    } catch (e) {
      errorMessage = 'Error: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


}
