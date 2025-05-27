import 'package:flutter/material.dart';

import '../notifications/notification_helper.dart';
import '../services/websocket.service.dart';

class NotificationController extends ChangeNotifier {
  late final WebSocketService _webSocketService;
  final List<String> _messages = [];

  List<String> get messages => _messages;

  NotificationController(String url) {
    _webSocketService = WebSocketService(url);
    _webSocketService.messages.listen((message) {
      _messages.add(message);
      NotificationHelper.showNotification("Nueva Alerta", message);
      notifyListeners();
    });
    _webSocketService.startListening();
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }
}


