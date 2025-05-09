import 'package:flutter/material.dart';
import 'package:ecuaranch/services/services.dart';

import '../../settings/settings.dart';

class GetWarehousesController extends ChangeNotifier {
  final OdooService odooService = OdooService();
  List<Map<String, dynamic>> warehouses = [];
  bool isLoading = false;
  String errorMessage = '';

  String db = Config.databaseName;
  String userId = Config.userId.toString();
  String password = Config.password;

  int offset = 0;
  int limit = 10;

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      warehouses = await odooService.getWarehouseFromOdoo(
        db,
        userId,
        password,
      );
      errorMessage = '';
    } catch (e) {
      errorMessage = e.toString();
      warehouses = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
