import 'package:flutter/material.dart';
import 'package:ecuaranch/services/services.dart';

import '../../dto/StableCreateDTO.dart';
import '../../settings/settings.dart';

class StablesController extends ChangeNotifier {
  final OdooService odooService = OdooService();
  List<Stable> stables = [];


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
      stables = await odooService.getStablesFromOdoo();
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
