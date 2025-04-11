import 'package:flutter/material.dart';
import 'package:ecuaranch/services/services.dart';

class StablesController extends ChangeNotifier {
  final OdooService odooService = OdooService();
  List<Map<String, dynamic>> stables = [];  // Lista de estables como Map<String, dynamic>
  bool isLoading = false;
  String errorMessage = '';

  String db = 'ecuaRanch';
  String userId = '2';
  String password = 'gabriel@nextgensolutions.group';

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();  

    try {
      stables = await odooService.getStablesFromOdoo(db, userId, password);
      errorMessage = '';  
    } catch (e) {
      errorMessage = e.toString();
      stables = []; 
    } finally {
      isLoading = false;
      notifyListeners();  
    }
  }
}
