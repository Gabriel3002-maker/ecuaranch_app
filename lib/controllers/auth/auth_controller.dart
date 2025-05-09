

import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

import '../../settings/settings.dart';

class UserController with ChangeNotifier {
  final OdooService odooService = OdooService();
  
  String db = Config.databaseName;

  String username = '';
  String password = '';

  // Estado de la carga
  bool isLoading = false;
  Map<String, dynamic>? userData;
  String? errorMessage;

  void setDb(String value) {
    db = value;
    notifyListeners();
  }

  void setUsername(String value) {
    username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();
    try {
      userData = await odooService.getUserFromOdoo(db, username, password);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      userData = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
