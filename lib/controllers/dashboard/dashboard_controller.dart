import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;

import '../../settings/settings.dart';

class DashboardController {
  final String apiKey = Config.weather;
  final String url = Config.baseUrl;

  // Obtener ubicación actual
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permiso de ubicación denegado');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Obtener clima actual
  Future<Map<String, dynamic>> getWeather() async {
    try {
      Position position = await getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      WeatherFactory wf = WeatherFactory(apiKey);
      Weather weather = await wf.currentWeatherByLocation(lat, lon);

      final temperature = weather.temperature?.celsius;
      final weatherDescription = weather.weatherDescription;
      final iconCode = weather.weatherIcon;

      String weatherIcon = _getWeatherIcon(iconCode ?? '');

      return {
        'temperature': temperature,
        'description': weatherDescription,
        'icon': weatherIcon,
      };
    } catch (e) {
      throw Exception('Error al cargar clima: $e');
    }
  }

  // Obtener ventas, gastos y ganancias
  Future<Map<String, dynamic>> getMonthlySalesAndExpenses() async {
    try {
      final response = await http.post(
        Uri.parse("$url/get_monthly_sales_and_expenses"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "db": Config.databaseName,
          "user_id": Config.userId.toString(),
          "password": Config.password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['status'] == 'success') {
          return {
            "total_sales": responseBody["total_sales"],
            "total_expenses": responseBody["total_expenses"],
            "net_profit": responseBody["net_profit"],
          };
        } else {
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['status']}');
        }
      } else {
        throw Exception("Error al obtener datos del servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  // Icono representativo del clima
  String _getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return '☀️';
      case '02d':
      case '02n':
        return '🌤️';
      case '03d':
      case '03n':
        return '☁️';
      case '04d':
      case '04n':
        return '☁️☁️';
      case '09d':
      case '09n':
        return '🌧️';
      case '10d':
      case '10n':
        return '🌦️';
      case '11d':
      case '11n':
        return '🌩️';
      case '13d':
      case '13n':
        return '❄️';
      case '50d':
      case '50n':
        return '🌫️';
      default:
        return '🌈';
    }
  }
}
