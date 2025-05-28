import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/stable_table.dart';
import '../../dto/StableCreateDTO.dart';
import '../../services/services.dart';
import '../../settings/settings.dart';

class StablesController extends ChangeNotifier {
  final Database db;
  final OdooService odooService = OdooService();
  List<Stable> stables = [];
  StablesController(this.db);

  bool isLoading = false;
  String errorMessage = '';

  String database = Config.databaseName;
  String userId = Config.userId.toString();
  String password = Config.password;

  int offset = 0;
  int limit = 10;

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      final connectivity = await Connectivity().checkConnectivity();

      if (connectivity != ConnectivityResult.none) {
        stables = await odooService.getStablesFromOdoo();

        await StablesTable.clear(db); // ✅ usa la instancia inyectada
        for (final stable in stables) {
          await StablesTable.insertStable(db, stable.toMap()); // ✅ igual aquí
        }
      } else {
        // Offline: carga desde SQLite
        final localData = await StablesTable.getStables(db); // ✅ aquí también
        stables = localData.map((e) => Stable.fromMap(e)).toList();
      }

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
