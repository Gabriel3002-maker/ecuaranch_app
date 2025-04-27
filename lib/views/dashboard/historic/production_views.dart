import 'package:ecuaranch/controllers/dashboard/historic/production_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimalHistoryProductionView extends StatelessWidget {
  final int animalId;
  final String db;
  final int userId;
  final String password;

  const AnimalHistoryProductionView({
    super.key,
    required this.animalId,
    required this.db,
    required this.userId,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => AnimalProductionController()
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
            'Historial de Producción',
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
        body: Consumer<AnimalProductionController>(
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

            if (controller.animalHistoryProduction.isEmpty) {
              return const Center(
                child: Text('No hay datos de producción registrados.'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.animalHistoryProduction.length,
              itemBuilder: (context, index) {
                final item = controller.animalHistoryProduction[index];

                final String date = item['x_studio_fecha'] ?? 'Sin fecha';
                final String description = item['x_name'] ?? 'Sin descripción';
                final num litros = item['x_studio_litros_producidos'] ?? 0;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: const Color(0xFFF4F4F4), // Aplicar color F4F4F4 a la tarjeta
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
                        _buildRow("📝 Detalle", description),
                        _buildRow("🥛 Litros Producidos", "$litros L"),
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
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
