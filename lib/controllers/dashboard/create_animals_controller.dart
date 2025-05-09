import 'package:ecuaranch/dto/animalCreateDTO.dart';
import 'package:ecuaranch/services/services.dart';
import 'package:flutter/material.dart';

import '../../settings/settings.dart';


class CreateAnimalsController with ChangeNotifier {
  final OdooService odooService = OdooService();

  final String _db = Config.databaseName;
  final int _userId =  Config.userId;
  final String _password = Config.password;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> createAnimal(AnimalDto animalDto) async {
    _isLoading = true;
    _errorMessage = '';
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
        xStudioUserId: animalDto.xStudioUserId,
        xStudioValue: animalDto.xStudioValue,
      );

      Map<String, dynamic> response = await odooService.createAnimal(enrichedDto);

      if (response['status'] == 'success') {
        debugPrint("Registrado Exitosamente");
      }

    } catch (e) {
      _errorMessage = 'Error al registrar el animal: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
