import 'package:ecuaranch/dto/animalCreateDTO.dart';
import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

class CreateAnimalsController with ChangeNotifier {
  final OdooService odooService = OdooService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = ''; // Para manejar mensajes de error
  String get errorMessage => _errorMessage;

  // Método para crear un animal
  Future<void> createAnimal(AnimalDto animalDto) async {
    _isLoading = true; // Inicia el estado de carga
    _errorMessage = ''; // Limpia cualquier error previo
    notifyListeners();

    try {
      Map<String, dynamic> response = await odooService.createAnimal(animalDto);

      if (response['status'] == 'success') {
        debugPrint("Registrado Exitosamente");
       }

    } catch (e) {
      _errorMessage = 'Error al registrar el animal: $e';
    } finally {
      // Cuando termina la llamada (éxito o error), se cambia el estado de carga
      _isLoading = false;
      notifyListeners();
    }
  }
}
