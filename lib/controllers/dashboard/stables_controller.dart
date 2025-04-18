import 'package:flutter/material.dart';
import 'package:ecuaranch/services/services.dart';

class StablesController extends ChangeNotifier {
  final OdooService odooService = OdooService();
  List<Map<String, dynamic>> stables = [];
  bool isLoading = false;
  String errorMessage = '';

  String db = 'ecuaRanch';
  String userId = '2';
  String password = 'gabriel@nextgensolutions.group';
  
  int offset = 0;
  int limit = 10;

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      stables = await odooService.getStablesFromOdoo(
        db,
        userId,
        password,
        offset: offset,
        limit: limit,
      );
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
