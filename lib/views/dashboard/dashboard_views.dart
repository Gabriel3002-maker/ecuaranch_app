import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Método para obtener la ubicación actual del dispositivo
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificamos si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Los servicios de ubicación están deshabilitados.');
    }

    // Verificamos si tenemos permiso para acceder a la ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permiso de ubicación denegado');
      }
    }

    // Obtenemos la ubicación actual
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Método para obtener el clima usando la API de OpenWeather
  Future<String> getWeather() async {
    const apiKey = 'ef760389ec275cbd3691c32e7aa8a557';
    try {
      // Obtenemos las coordenadas actuales
      Position position = await _getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      // Construimos la URL para la API
      final url =
          'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=hourly,daily&appid=$apiKey&units=metric';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final temperature = data['current']['temp'];
        final weatherDescription = data['current']['weather'][0]['description'];
        return '$temperature°C, $weatherDescription';
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Error al cargar clima: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const buttonColor = Color(0xFF0A5A57); 
    const cardColor = Color(0xFFF4F4F4);
    const metaProgreso = 5000; 

    Widget infoCard({required String title, required Widget child}) {
      return Expanded(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          color: cardColor, 
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                child,
              ],
            ),
          ),
        ),
      );
    }

    Widget dashboardButton({
      required String imagePath, 
      required String label,
      required VoidCallback onTap,
    }) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: buttonColor, 
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, width: 40, height: 40), 
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white, 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                infoCard(
                  title: 'Ejemplares',
                  child: const Column(
                    children: [
                      Text('120', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Machos: 60 - Hembras: 60'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                infoCard(
                  title: 'Calendario',
                  child: FutureBuilder<String>(
                    future: getWeather(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Column(
                          children: [
                            Icon(Icons.calendar_today, size: 40),
                            SizedBox(height: 8),
                            CircularProgressIndicator(),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return const  Column(
                          children: [
                            Icon(Icons.calendar_today, size: 40),
                            SizedBox(height: 8),
                            Text('Error al cargar clima'),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            const Icon(Icons.calendar_today, size: 40),
                            const SizedBox(height: 8),
                            Text(snapshot.data ?? 'No disponible'),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Fila 2: Producción
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              color: cardColor, // Color de fondo de la tarjeta de producción
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Producción - Meta Mensual: \$10,000',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: metaProgreso / 10000,
                      minHeight: 20,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(buttonColor),
                    ),
                    const SizedBox(height: 8),
                    Text('\$${metaProgreso.toStringAsFixed(0)} alcanzado'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Fila 3: Primer grupo de botones
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: dashboardButton(
                              imagePath: 'assets/icons/list_stables.png', 
                              label: 'Listado de Establos',
                              onTap: () => Navigator.pushNamed(context, '/list-stables'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: dashboardButton(
                              imagePath: 'assets/icons/animals.png',
                              label: 'Listado de Animales',
                              onTap: () => Navigator.pushNamed(context, '/list-animals'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: dashboardButton(
                              imagePath: 'assets/icons/animal_register.png', 
                              label: 'Registrar Animal',
                              onTap: () => Navigator.pushNamed(context, '/create-animal'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Fila 4: Subfila de botones extra
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                dashboardButton(
                  imagePath: 'assets/icons/animal_health.png', 
                  label: 'Salud',
                  onTap: () {},
                ),
                dashboardButton(
                  imagePath: 'assets/icons/animal_events.png', 
                  label: 'Eventos',
                  onTap: () {},
                ),
                dashboardButton(
                  imagePath: 'assets/icons/finances.png', 
                  label: 'Finanzas',
                  onTap: () {},
                ),
                dashboardButton(
                  imagePath: 'assets/icons/logout.png',
                  label: 'dashboard.logout'.tr(),
                  onTap: () => Navigator.pushReplacementNamed(context, '/'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
