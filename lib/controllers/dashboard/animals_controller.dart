import 'package:flutter/material.dart';
import 'package:ecuaranch/services/services.dart';

import '../../settings/settings.dart';

class AnimalsController extends ChangeNotifier {
  final OdooService odooService = OdooService();
  List<Map<String, dynamic>> animals = [];  
  bool isLoading = false;
  String errorMessage = '';

  String db = Config.databaseName;
  String userId = Config.userId.toString();
  String password = Config.password;

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();  

    try {
      animals = await odooService.getAnimalsFromOdoo(db, userId, password);
      errorMessage = '';  
    } catch (e) {
      errorMessage = e.toString();
      animals = []; 
    } finally {
      isLoading = false;
      notifyListeners();  
    }
  }
}
