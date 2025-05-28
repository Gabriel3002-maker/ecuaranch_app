import 'package:ecuaranch/controllers/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = DashboardController();
  late Future<Map<String, dynamic>> nAnimalMachoData;
  late Future<Map<String, dynamic>> nAnimalHembraData;
  late Future<Map<String, dynamic>> weatherFuture;
  late Future<Map<String, dynamic>> financeFuture;

  @override
  void initState() {
    super.initState();
    // Inicializar los futures
    weatherFuture = controller.getWeather();
    financeFuture = controller.getMonthlySalesAndExpenses();
  }

  @override
  Widget build(BuildContext context) {
    const buttonColor = Color(0xFF0A5A57);
    const cardColor = Color(0xFFF4F4F4);

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
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, width: 36, height: 36),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Opacity(
                    opacity: 0.06,
                    child: Image.asset(
                      'assets/images/logoecuaranch.png',
                      width: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/icons/fondo.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<Map<String, dynamic>>(
                        future: controller.getAnimalCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());  // Centered loading indicator
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            final machoCount = snapshot.data!['macho'] ?? 0;
                            final hembraCount = snapshot.data!['hembra'] ?? 0;
                            final totalAnimals = snapshot.data!['total'] ?? 0;

                            return Padding(
                              padding: const EdgeInsets.all(16), // Padding around the text
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '$totalAnimals',
                                        style: const TextStyle(
                                          color: Color(0xFFF08235), // naranja
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Ejemplares',
                                        style: TextStyle(
                                          color: Color(0xFF60463D), // marrón oscuro
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10), // espacio antes de machos y hembras

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center, // centra el grupo
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            'Machos',
                                            style: TextStyle(
                                              color: Color(0xFF929292), // gris
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '$machoCount',
                                            style: const TextStyle(
                                              color: Color(0xFF929292),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(width: 10), // espacio horizontal entre machos y hembras

                                      Column(
                                        children: [
                                          const Text(
                                            'Hembras',
                                            style: TextStyle(
                                              color: Color(0xFF929292),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '$hembraCount',
                                            style: const TextStyle(
                                              color: Color(0xFF929292),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                            );
                          } else {
                            return const Center(
                              child: Text(
                                'No se han encontrado datos.',
                                style: TextStyle(color: Colors.black, fontSize: 16), // Text color changed to black
                              ),
                            );
                          }
                        },
                      ), // FutureBuilder para el clima
                      FutureBuilder<Map<String, dynamic>>(
                        future: weatherFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Column(
                              children: [
                                Icon(Icons.cloud, size: 36, color: Colors.white),
                                SizedBox(height: 4),
                                CircularProgressIndicator(strokeWidth: 2),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return const Column(
                              children: [
                                Icon(Icons.error, size: 36, color: Colors.white),
                                SizedBox(height: 4),
                                Text('Error clima', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                              ],
                            );
                          } else if (snapshot.hasData) {
                            final weatherData = snapshot.data!;
                            final temperature = weatherData['temperature'].toStringAsFixed(0);
                            final description = _translateWeatherDescription(weatherData['description']);
                            return Column(
                              children: [
                                Text(weatherData['icon'], style: const TextStyle(fontSize: 34, color: Colors.white)),
                                Text('$temperature°C', style: const TextStyle(fontSize: 18, color: Colors.white)),
                                Text(description, style: const TextStyle(fontSize: 14, color: Colors.white)),
                              ],
                            );
                          } else {
                            return const Text('Sin datos', style: TextStyle(color: Colors.white));
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Sección de Producción y Finanzas
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  color: const Color(0xFF0A5A57),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: financeFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error al cargar finanzas: ${snapshot.error}', style: const TextStyle(color: Colors.white));
                        } else if (snapshot.hasData) {
                          final data = snapshot.data!;
                          final totalSales = (data["total_sales"] ?? 0).toDouble();
                          final totalExpenses = (data["total_expenses"] ?? 0).toDouble();
                          final netProfit = (data["net_profit"] ?? 0).toDouble();
                          const meta = 10000.0;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Producción - Meta Mensual: \$10,000',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: (totalSales / meta).clamp(0.0, 1.0),
                                minHeight: 18,
                                backgroundColor: Colors.black26,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                              const SizedBox(height: 6),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('\$0', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  Text('\$1,000', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  Text('\$5,000', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  Text('\$10,000', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('\$${totalSales.toStringAsFixed(2)} alcanzado', style: const TextStyle(color: Colors.white)),
                              const Divider(height: 16, color: Colors.white30),
                              Text('Gastos: \$${totalExpenses.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                              Text('Ganancia Neta: \$${netProfit.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          );
                        } else {
                          return const Text('Sin datos disponibles', style: TextStyle(color: Colors.white));
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Botones principales
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: dashboardButton(
                              imagePath: 'assets/icons/manufacturing.png',
                              label: 'Listado de Establos',
                              onTap: () => Navigator.pushNamed(context, '/list-stables'),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: dashboardButton(
                              imagePath: 'assets/icons/animals.png',
                              label: 'Listado de Animales',
                              onTap: () => Navigator.pushNamed(context, '/list-animals'),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: dashboardButton(
                              imagePath: 'assets/icons/animal_register.png',
                              label: 'Registrar Animal',
                              onTap: () => Navigator.pushNamed(context, '/create-partner-animal'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 4,
                  children: [
                    dashboardButton(
                      imagePath: 'assets/icons/health.png',
                      label: 'Alerta Salud',
                      onTap: () => Navigator.pushNamed(context, '/alert-heath'),
                    ),
                    dashboardButton(
                      imagePath: 'assets/icons/weight.png',
                      label: 'Alerta  Peso',
                      onTap: () => Navigator.pushNamed(context, '/alert-weight'),
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
          ],
        ),
      ),
    );
  }

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
        return 'Lluvias ligeras';
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
