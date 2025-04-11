import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonColor = const Color(0xFF6B8E23); // Verde oliva

    Widget dashboardButton({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'dashboard.dashboard'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: buttonColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500), // Limita el ancho
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                shrinkWrap: true, // Importante para que GridView no ocupe toda la pantalla
                physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll del grid
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  dashboardButton(
                    icon: Icons.list,
                    label: 'Listado de Establos',
                    onTap: () => Navigator.pushNamed(context, '/list-stables'),
                  ),
                  dashboardButton(
                    icon: Icons.list_alt,
                    label: 'Listado de Animales',
                    onTap: () => Navigator.pushNamed(context, '/list-animals'),
                  ),
                  dashboardButton(
                    icon: Icons.add_circle_outline,
                    label: 'Registrar Animal',
                    onTap: () => Navigator.pushNamed(context, '/create-animal'),
                  ),
                  dashboardButton(
                    icon: Icons.logout,
                    label: 'dashboard.logout'.tr(),
                    onTap: () => Navigator.pushReplacementNamed(context, '/'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
