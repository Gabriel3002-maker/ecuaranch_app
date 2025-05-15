import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ecuaranch/views/auth/login_views.dart';

// Controlador para manejar los permisos de ubicación
class PermissionController {
  final GlobalKey<NavigatorState> navigatorKey;

  PermissionController(this.navigatorKey);

  // Verifica y solicita el permiso de ubicación
  Future<void> checkPermissionStatus() async {
    bool isLocationEnabled = await _isLocationServiceEnabled();

    if (isLocationEnabled) {
      bool hasPermission = await _checkLocationPermission();
      if (hasPermission) {
        _navigateToLogin();  // Si el permiso está concedido, redirige al login
      } else {
        _requestPermission();  // Si no tiene permiso, solicita el permiso
      }
    } else {
      _showLocationServiceDisabledDialog();  // Si el servicio de ubicación está deshabilitado
    }
  }

  // Verifica si el servicio de ubicación está habilitado
  Future<bool> _isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Verifica si el permiso de ubicación está concedido
  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse || permission == LocationPermission.always;
  }

  // Solicita el permiso de ubicación
  Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      // Si el permiso es denegado, muestra el diálogo o redirige a la configuración
      _showPermissionDeniedDialog();
    } else {
      // Si el permiso es concedido, redirige al login
      _navigateToLogin();
    }
  }

  // Muestra un cuadro de diálogo informando que el servicio de ubicación está deshabilitado
  void _showLocationServiceDisabledDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Service Disabled'),
          content: const Text('Please enable location services to continue.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Cierra el cuadro de diálogo
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Muestra un cuadro de diálogo solicitando al usuario que habilite el permiso
  void _showPermissionDeniedDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Permission Denied'),
          content: const Text('Please enable location permissions to continue.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Cierra el cuadro de diálogo
                openAppSettings();  // Redirige a la configuración de la app
              },
              child: const Text('Go to Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Cierra el cuadro de diálogo
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Navega a la pantalla de login
  void _navigateToLogin() {
    navigatorKey.currentState?.pushReplacementNamed('/');
  }
}
