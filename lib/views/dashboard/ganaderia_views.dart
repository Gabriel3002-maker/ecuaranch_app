import 'package:ecuaranch/controllers/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class GanaderiaScreen extends StatelessWidget {
  final DashboardController controller = DashboardController();

  GanaderiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const buttonColor = Color(0xFF0A5A57);
    const sectionTitleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

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
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget sectionCard(String title, List<Widget> buttons) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(title, style: sectionTitleStyle),
            ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: buttons
                .map(
                  (button) => SizedBox(
                width: 100, // Ajusta esto según tu diseño
                child: button,
              ),
            )
                .toList(),
          ),
          const SizedBox(height: 20),
        ],
      );
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Panel Ganadero',
          style: TextStyle(color: Colors.orange), // Texto en blanco para mejor contraste
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black), // Para que los íconos también sean blancos
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Opacity(
                  opacity: 0.06,
                  child: Image.asset(
                    'assets/images/logoecuaranch.png', // Ruta de la imagen
                    width: 260,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionCard("Registro de Datos", [
                  dashboardButton(
                    imagePath: 'assets/icons/person_register.png',
                    label: 'Registrar Persona',
                    onTap: () => Navigator.pushNamed(context, '/create-partner'),
                  ),
                  dashboardButton(
                    imagePath: 'assets/icons/animal_register.png',
                    label: 'Registrar Animal',
                    onTap: () => Navigator.pushNamed(context, '/create-partner-animal'),
                  ),
                  dashboardButton(
                    imagePath: 'assets/icons/list_stables.png',
                    label: 'Registrar Granja',
                    onTap: () => Navigator.pushNamed(context, '/create-stables'),
                  ),
                ]),
                sectionCard("Gestión de Oportunidades", [
                  dashboardButton(
                    imagePath: 'assets/icons/oportunity.png',
                    label: 'Ver Oportunidades',
                    onTap: () => Navigator.pushNamed(context, '/list-leads'),
                  ),
                ]),
                sectionCard("Revisión y Administración", [
                  dashboardButton(
                    imagePath: 'assets/icons/production.png',
                    label: 'Lista de Fábricas',
                    onTap: () => Navigator.pushNamed(context, '/list-factory'),
                  ),
                  dashboardButton(
                    imagePath: 'assets/icons/sales.png',
                    label: 'Registro de Gastos',
                    onTap: () => Navigator.pushNamed(context, '/list-expenses'),
                  ),
                  dashboardButton(
                    imagePath: 'assets/icons/manufacturing.png',
                    label: 'Administrar Almacenes',
                    onTap: () => Navigator.pushNamed(context, '/list-warehouses'),
                  ),
                ]),

              ],
            ),
          ),
        ],
      ),
    );

  }
}
