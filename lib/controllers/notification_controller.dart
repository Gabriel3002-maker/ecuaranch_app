// controllers/notification_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';

import '../services/websocket.service.dart';

class NotificationController with ChangeNotifier {
  final WebSocketService _webSocketService;
  List<String> notificaciones = [];

  NotificationController(String wsUrl)
      : _webSocketService = WebSocketService(wsUrl) {
    _webSocketService.startListening();
    _webSocketService.messages.listen((message) {
      notificaciones.add(message);
      notifyListeners();  // Notifica a los listeners que hay cambios
    });
  }

  List<String> get getNotificaciones => notificaciones;

  // Dispose cuando ya no necesites el controlador
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }
}
