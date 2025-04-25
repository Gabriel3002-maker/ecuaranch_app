import 'package:ecuaranch/controllers/dashboard/historic/observation_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimalHistoryObservationView extends StatelessWidget {
  final int animalId;
  final String db;
  final int userId;
  final String password;

  const AnimalHistoryObservationView({
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
      create: (_) => AnimalHistoryObservationController()
        ..fetchAnimalHistory(
          db: db,
          userId: userId,
          password: password,
          animalId: animalId,
        ),
      child: Scaffold(
        backgroundColor: Colors.white, // Fondo blanco
        appBar: AppBar(
          backgroundColor: Colors.white, // Fondo blanco en el AppBar
          automaticallyImplyLeading: false, // Desactivar el botón de retroceso automático
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black), // Ícono de retroceso negro
            onPressed: () {
              Navigator.pop(context); // Botón de retroceso
            },
          ),
          title: const Text(
            'Historial de Observaciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold, // Texto en negrita
              color: Colors.black, // Texto en color negro
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black), // Ícono de notificaciones negro
              onPressed: () {
                // Acción de notificaciones
              },
            ),
          ],
        ),
        body: Consumer<AnimalHistoryObservationController>(
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

            if (controller.animalHistoryObservation.isEmpty) {
              return const Center(
                child: Text('No hay observaciones registradas.'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.animalHistoryObservation.length,
              itemBuilder: (context, index) {
                final item = controller.animalHistoryObservation[index];

                final String date = item['x_studio_fecha_1'] ?? 'Sin fecha';
                final String description = item['x_name'] ?? 'Sin descripción';

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
                        _buildRow("📝 Observación", description),
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
