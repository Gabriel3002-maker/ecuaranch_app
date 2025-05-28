import 'package:ecuaranch/views/dashboard/addRegisters/register_feeding_views.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_growth_views.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_heatlh_views.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_observation_views.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_production_views.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_reproduction_views.dart';
import 'package:flutter/material.dart';

// Definir color como constante
const Color themeColor = Color(0xFF0A5A57);

class RegisterInfoView extends StatelessWidget {
  final int animalId;

  const RegisterInfoView({
    super.key,
    required this.animalId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo general blanco
      appBar: AppBar(
        title: const Text(
          'Registro',
          style: TextStyle(color: Colors.black), // Texto en blanco para mejor contraste
        ),
        iconTheme: const IconThemeData(color: Colors.black), // Para que los íconos también sean blancos
      ),
      body: Stack(
        children: [
          // Fondo con la imagen con opacidad
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Opacity(
                  opacity: 0.06, // Opacidad de la imagen
                  child: Image.asset(
                    'assets/images/logoecuaranch.png',
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          // Contenido principal
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildButton(context, "Registrar Observaciones", RegisterObservationView(animalId: animalId), Icons.note_add),
                _buildButton(context, "Registrar Salud", RegisterHealthView(animalId: animalId), Icons.health_and_safety),
                _buildButton(context, "Registrar Crecimiento y Peso", RegisterGrowthView(animalId: animalId), Icons.accessibility),
                _buildButton(context, "Registrar Reproducción", RegisterReproductionView(animalId: animalId), Icons.favorite),
                _buildButton(context, "Registrar Alimentación", RegisterFeedingView(animalId: animalId), Icons.fastfood),
                _buildButton(context, "Registrar Producción", RegisterProductionView(animalId: animalId), Icons.production_quantity_limits),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget page, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor, // Color de fondo del botón
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24), // El ícono al principio
              const SizedBox(width: 8), // Espacio entre el ícono y el texto
              Text(
                title,
                style: const TextStyle(color: Colors.white), // Texto blanco
              ),
            ],
          ),
        ),
      ),
    );
  }
}
