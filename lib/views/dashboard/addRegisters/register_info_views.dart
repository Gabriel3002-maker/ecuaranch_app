import 'package:ecuaranch/views/dashboard/addRegisters/register_feeding_views.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_growth_views.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_heatlh_views.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_observation_views.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_production_views.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_reproduction_views,dart';
import 'package:flutter/material.dart';


class RegisterInfoView extends StatelessWidget {
  final int animalId;

  const RegisterInfoView({
    super.key,
    required this.animalId,
  });

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF6B8E23);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Información"),
        backgroundColor: themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Animal ID: $animalId",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildButton(context, "Registrar Observaciones", RegisterObservationView(animalId: animalId)),
            _buildButton(context, "Registrar Salud", RegisterHealthView(animalId: animalId)),
            _buildButton(context, "Registrar Crecimiento y Peso", RegisterGrowthView(animalId: animalId)),
            _buildButton(context, "Registrar Reproducción", RegisterReproductionView(animalId: animalId)),
            _buildButton(context, "Registrar Alimentación", RegisterFeedingView(animalId: animalId)),
            _buildButton(context, "Registrar Producción", RegisterProductionView(animalId: animalId)),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[700],
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          },
          child: Text(title),
        ),
      ),
    );
  }
}
