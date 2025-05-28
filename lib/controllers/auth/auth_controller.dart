import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../load_services/auth_service.dart';

class UserController with ChangeNotifier {
  final Database db;
  final AuthService authService;

  UserController(this.db) : authService = AuthService(db);

  String username = '';
  String password = '';

  bool isLoading = false;
  int? userId;
  String? errorMessage;

  void setUsername(String value) {
    username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<void> login() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Intentar login online
      userId = await authService.loginAndSave(username, password);
    } catch (e) {
      // Si falla (ej. sin internet), intentar login offline
      final localUser = await authService.getLocalUser(username);
      if (localUser != null && localUser['password'] == password) {
        userId = localUser['id'];
      } else {
        errorMessage = "No hay conexión y usuario no encontrado localmente.";
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
