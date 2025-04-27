import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class DashboardController {
  final String apiKey = 'ef760389ec275cbd3691c32e7aa8a557'; // Tu API key de OpenWeather

  // Método para obtener la ubicación actual del dispositivo
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

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Método para obtener el clima usando la librería weather
  Future<Map<String, dynamic>> getWeather() async {
    try {
      // Obtener la ubicación actual
      Position position = await getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      WeatherFactory wf = WeatherFactory(apiKey);

      Weather weather = await wf.currentWeatherByLocation(lat, lon);

      final temperature = weather.temperature?.celsius; // Temperatura en grados Celsius
      final weatherDescription = weather.weatherDescription; // Descripción del clima
      final iconCode = weather.weatherIcon; // Código del icono del clima

      // Mapeo del ícono del clima
      String weatherIcon = _getWeatherIcon(iconCode!);

      // Retornar la información del clima junto con el ícono
      return {
        'temperature': temperature,
        'description': weatherDescription,
        'icon': weatherIcon,
      };
    } catch (e) {
      throw Exception('Error al cargar clima: $e');
    }
  }

  String _getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return '☀️'; // Sol
      case '02d':
      case '02n':
        return '🌤️'; // Nubes dispersas
      case '03d':
      case '03n':
        return '☁️'; // Nubes
      case '04d':
      case '04n':
        return '☁️☁️'; // Nubes densas
      case '09d':
      case '09n':
        return '🌧️'; // Lluvia
      case '10d':
      case '10n':
        return '🌦️'; // Lluvia con sol
      case '11d':
      case '11n':
        return '🌩️'; // Tormenta
      case '13d':
      case '13n':
        return '❄️'; // Nieve
      case '50d':
      case '50n':
        return '🌫️'; // Neblina
      default:
        return '🌈'; // Icono por defecto
    }
  }
}
