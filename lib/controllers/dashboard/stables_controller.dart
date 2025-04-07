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

  // Llamar al método fetchUserData al cargar la vista
  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();  // Notificamos que estamos cargando

    try {
      stables = await odooService.getStablesFromOdoo(db, userId, password);
      errorMessage = '';  // Reseteamos cualquier error
    } catch (e) {
      errorMessage = e.toString();
      stables = [];  // Limpiamos la lista en caso de error
    } finally {
      isLoading = false;
      notifyListeners();  // Notificamos que la carga ha terminado
    }
  }
}
