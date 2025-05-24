import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ecuaranch/services/services.dart';

import '../../settings/settings.dart';

class HealthAlertController extends ChangeNotifier {
  final OdooService odooService = OdooService();
  List<Map<String, dynamic>> health = [];
  bool isLoading = false;
  String errorMessage = '';

  String db = Config.databaseName;
  String userId = Config.userId.toString();
  String password = Config.password;

  // Método para obtener las alertas de salud de los animales
  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      health = await odooService.getAnimalsHealthAlerts(db, userId, password);
      errorMessage = '';
    } catch (e) {
      errorMessage = e.toString();
      health = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Método para tomar acción sobre una alerta (desactivarla)
  Future<void> takeActionOnAlert(int alertId) async {
    isLoading = true;
    notifyListeners();

    try {
      await odooService.updateHealthAlerts(db, userId, password, alertId);
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
