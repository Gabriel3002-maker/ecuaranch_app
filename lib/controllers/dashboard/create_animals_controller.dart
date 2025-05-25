import 'package:ecuaranch/dto/animalCreateDTO.dart';
import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

import '../../settings/settings.dart';

class CreateAnimalsController with ChangeNotifier {
  final OdooService odooService = OdooService();

  final String _db = Config.databaseName;
  final int _userId = Config.userId;
  final String _password = Config.password;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Nuevas variables para almacenar el mensaje y el ID
  String _successMessage = '';
  String get successMessage => _successMessage;

  int? _animalId;
  int? get animalId => _animalId;

  Future<void> createAnimal(AnimalDto animalDto) async {
    _isLoading = true;
    _errorMessage = '';
    _successMessage = '';
    _animalId = null;  // Reiniciamos el animalId cada vez que se envíe el formulario
    notifyListeners();

    try {
      final enrichedDto = AnimalDto(
        db: _db,
        userId: _userId,
        password: _password,
        xName: animalDto.xName,
        xStudioPartnerId: animalDto.xStudioPartnerId,
        xStudioAlimentacionInicial1: animalDto.xStudioAlimentacionInicial1,
        xStudioPesoInicial: animalDto.xStudioPesoInicial,
        xStudioDateStart: animalDto.xStudioDateStart,
        xStudioGenero1: animalDto.xStudioGenero1,
        xStudioCharField18c1io38ib86: animalDto.xStudioCharField18c1io38ib86,
        xStudioDestinadoA: animalDto.xStudioDestinadoA,
        xStudioEstadoDeSalud1: animalDto.xStudioEstadoDeSalud1,
        xStudioUserId: _userId,
        xStudioValue: animalDto.xStudioValue,
        xStudioEstabloAlQuePertenece: animalDto.xStudioEstabloAlQuePertenece
      );

      Map<String, dynamic> response = await odooService.createAnimal(enrichedDto);

      if (response['status'] == 'success') {
        _successMessage = response['message'] ?? 'Animal creado exitosamente';
        _animalId = response['animal_id']?[0];  // Accediendo al ID del animal
        debugPrint("Registrado Exitosamente. Animal ID: $_animalId");
      } else {
        _errorMessage = 'No se pudo crear el animal';
      }
    } catch (e) {
      _errorMessage = 'Error al registrar el animal: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
