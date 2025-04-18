import 'package:ecuaranch/controllers/dashboard/historic/health_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimalHistoryHealthView extends StatelessWidget {
  final int animalId;
  final String db;
  final int userId;
  final String password;

  const AnimalHistoryHealthView({
    super.key,
    required this.animalId,
    required this.db,
    required this.userId,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF6B8E23);

    return ChangeNotifierProvider(
      create: (_) => AnimalHistoryHealthController()
        ..fetchAnimalHistory(
          db: db,
          userId: userId,
          password: password,
          animalId: animalId,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Historial de Salud'),
          backgroundColor: themeColor,
        ),
        body: Consumer<AnimalHistoryHealthController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  controller.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (controller.animalHistoryHealth.isEmpty) {
              return const Center(
                child: Text('No hay observaciones registradas.'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.animalHistoryHealth.length,
              itemBuilder: (context, index) {
                final item = controller.animalHistoryHealth[index];

                final String date = item['create_date'] ?? 'Sin fecha';
                final String description = item['x_name'] ?? 'Sin descripción';
                final String stateHealth = item['x_studio_estado_de_salud'] ?? 'Sin estado';

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📅 Fecha: $date',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        const SizedBox(height: 8),
                        _buildRow('❤️‍🩹 Estado de Salud', stateHealth),
                        _buildRow('📝 Observación', description),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
