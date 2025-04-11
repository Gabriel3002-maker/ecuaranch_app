import 'package:flutter/material.dart';
import 'package:ecuaranch/services/services.dart';

class AnimalsController extends ChangeNotifier {
  final OdooService odooService = OdooService();
  List<Map<String, dynamic>> animals = [];  
  bool isLoading = false;
  String errorMessage = '';

  String db = 'ecuaRanch';
  String userId = '2';
  String password = 'gabriel@nextgensolutions.group';

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
