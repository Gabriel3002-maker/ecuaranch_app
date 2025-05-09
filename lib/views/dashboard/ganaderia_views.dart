import 'package:ecuaranch/controllers/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class GanaderiaScreen extends StatelessWidget {
  final DashboardController controller = DashboardController();

  GanaderiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const buttonColor = Color(0xFF0A5A57);
    const cardColor = Color(0xFFF4F4F4);
    const metaProgreso = 5000;

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
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
            const SizedBox(width: 8),
            // Tarjeta de producción
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              color: cardColor,
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

            // Grid de botones reorganizados
            SizedBox(
              height: 520, // Espacio suficiente para evitar overflow
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  // Sección: Registro
                  dashboardButton(
                    imagePath: 'assets/icons/person_register.png',
                    label: 'Registrar Persona',
                    onTap: () => Navigator.pushNamed(context, '/create-partner'),
                  ),
                  dashboardButton(
                    imagePath: 'assets/icons/animal_register.png',
                    label: 'Registrar Animal',
                    onTap: () => Navigator.pushNamed(context, '/create-animal'),
                  ),
                  dashboardButton(
                    imagePath: 'assets/icons/list_stables.png',
                    label: 'Registrar Establos',
                    onTap: () => Navigator.pushNamed(context, '/create-stables'),
                  ),

                  // Sección: Otros
                  dashboardButton(
                    imagePath: 'assets/icons/oportunity.png',
                    label: 'Oportunidades',
                    onTap: () => Navigator.pushNamed(context, '/list-leads'),
                  ),
                  dashboardButton(
                    imagePath: 'assets/icons/production.png',
                    label: 'Fábricas',
                    onTap: () => Navigator.pushNamed(context, '/list-factory'),
                  ),
                  dashboardButton(
                    imagePath: 'assets/icons/sales.png',
                    label: 'Gastos',
                    onTap: () => Navigator.pushNamed(context, '/list-expenses'),
                  ),
                  dashboardButton(
                    imagePath: 'assets/icons/manufacturing.png',
                    label: 'Almacenes',
                    onTap: () => Navigator.pushNamed(context, '/list-warehouses'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
