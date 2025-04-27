import 'package:ecuaranch/controllers/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = DashboardController(); // Instanciamos el controlador

  DashboardScreen({super.key});

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
                  title: 'Clima', // Cambié el título para que sea más claro
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: controller.getWeather(), // Usamos el controlador para obtener el clima
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Column(
                          children: [
                            Icon(Icons.cloud, size: 40),
                            SizedBox(height: 8),
                            CircularProgressIndicator(),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        // Manejo de errores
                        return Column(
                          children: [
                            const Icon(Icons.error, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              'Error: ${snapshot.error}',  // Muestra el mensaje de error
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      } else if (snapshot.hasData) {
                        final weatherData = snapshot.data!;
                        final temperature = weatherData['temperature'].toStringAsFixed(0); // Redondeamos la temperatura
                        final description = _translateWeatherDescription(weatherData['description']); // Traducimos la descripción

                        return Column(
                          children: [
                            // Mostramos el ícono y la temperatura
                            Text(weatherData['icon'], style: const TextStyle(fontSize: 40)), // Icono de clima
                            Text('$temperature°C', style: const TextStyle(fontSize: 24)),
                            Text(description, style: const TextStyle(fontSize: 16)),
                          ],
                        );
                      } else {
                        return const Text('Sin datos disponibles');
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

  // Método para traducir la descripción del clima a español
  String _translateWeatherDescription(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return 'Cielo despejado';
      case 'few clouds':
        return 'Pocas nubes';
      case 'scattered clouds':
        return 'Nubes dispersas';
      case 'broken clouds':
        return 'Nubes rotas';
      case 'shower rain':
        return 'Lluvias';
      case 'light rain':
        return 'Lluvias Ligeras';
      case 'thunderstorm':
        return 'Tormenta';
      case 'snow':
        return 'Nieve';
      case 'mist':
        return 'Niebla';
      default:
        return description; 
    }
  }
}
