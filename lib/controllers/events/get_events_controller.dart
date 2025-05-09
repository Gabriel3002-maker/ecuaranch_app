import 'package:flutter/material.dart';
import 'package:ecuaranch/services/services.dart';

import '../../settings/settings.dart';

class GetEventsControllerController extends ChangeNotifier {
  final OdooService odooService = OdooService();
  List<Map<String, dynamic>> events = [];
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
      events = await odooService.getEventsFromOdoo(
        db,
        userId,
        password,
      );
      errorMessage = '';
    } catch (e) {
      errorMessage = e.toString();
      events = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
