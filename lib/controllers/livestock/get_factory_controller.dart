import 'package:flutter/material.dart';
import 'package:ecuaranch/services/services.dart';

import '../../settings/settings.dart';

class GetFactoryController extends ChangeNotifier {
  final OdooService odooService = OdooService();
  List<Map<String, dynamic>> factory = [];
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
      factory = await odooService.getFactoryFromOdoo(
        db,
        userId,
        password,
      );
      errorMessage = '';
    } catch (e) {
      errorMessage = e.toString();
      factory = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
