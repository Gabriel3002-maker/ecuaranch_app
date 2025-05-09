// services/websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel _channel;
  final StreamController<String> _messageStreamController = StreamController<String>();

  WebSocketService(String url) : _channel = WebSocketChannel.connect(Uri.parse(url));

  // Stream para enviar notificaciones cuando se recibe un mensaje
  Stream<String> get messages => _messageStreamController.stream;

  // Conectar al WebSocket y escuchar mensajes
  void startListening() {
    _channel.stream.listen((data) {
      try {
        final Map<String, dynamic> parsedData = jsonDecode(data);
        // Aquí puedes procesar los datos y enviar notificaciones
        String notification = _parseMessage(parsedData);
        _messageStreamController.add(notification);
      } catch (e) {
        print("❌ Error al procesar mensaje: $e");
      }
    });
  }

  // Método para procesar el mensaje JSON
  String _parseMessage(Map<String, dynamic> data) {
    if (data.containsKey('peso_actual')) {
      // Notificación de peso
      return '🐄 [Peso] Animal: ${data['animal_nombre'] ?? "Desconocido"} | Descripción: ${data['nombre']} | Peso actual: ${data['peso_actual']}kg | Diferencia: ${data['diferencia']}kg';
    } else if (data.containsKey('animal_nombre')) {
      // Notificación de salud
      return '🩺 [Salud] Animal: ${data['animal_nombre']} | Alerta: ${data['nombre']} | Fecha: ${data['fecha']}';
    } else {
      // Otro tipo de alerta desconocida
      return '📦 Otra alerta: ${jsonEncode(data)}';
    }
  }

  // Cerrar el WebSocket cuando no sea necesario
  void dispose() {
    _channel.sink.close();
    _messageStreamController.close();
  }
}
