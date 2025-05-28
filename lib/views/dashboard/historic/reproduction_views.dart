import 'package:ecuaranch/controllers/dashboard/historic/reproduction_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimalHistoryReproductionView extends StatelessWidget {
  final int animalId;
  final String db;
  final int userId;
  final String password;

  const AnimalHistoryReproductionView({
    super.key,
    required this.animalId,
    required this.db,
    required this.userId,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnimalHistoryReproductionController()
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
            'Historial de Reproducción',
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
        body: Stack(
          children: [
            // Fondo con el logo
            Positioned.fill(
              child: IgnorePointer( // Evita que el fondo interfiera con la interacción
                child: Center(
                  child: Opacity(
                    opacity: 0.06, // Opacidad baja
                    child: Image.asset(
                      'assets/images/logoecuaranch.png', // Ruta del logo
                      width: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Consumer<AnimalHistoryReproductionController>(
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

                if (controller.animalHistoryReproduction.isEmpty) {
                  return const Center(
                    child: Text('No hay datos de reproducción registrados.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.animalHistoryReproduction.length,
                  itemBuilder: (context, index) {
                    final item = controller.animalHistoryReproduction[index];

                    final String date = item['create_date'] ?? 'Sin fecha';
                    final String metodoReproduccion = item['x_studio_metodo_reproduccion'] ?? 'Sin descripción';
                    final String fechaInseminacion = item['x_studio_fecha_de_inseminacin'] ?? 'Sin dato';
                    final String fechaCelo = item['x_studio_fecha_de_inicio_del_celo'] ?? 'Sin dato';
                    final num numeroCrias = item['x_studio_nmero_de_cras_esperadas'] ?? 0;
                    final String embarazoConfirmado = item['x_studio_embarazo_confirmado'] ?? 'Sin dato';

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
                            Text('📅 Fecha de registro: $date',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                            const SizedBox(height: 8),
                            _buildRow("Método de Reproducción", metodoReproduccion),
                            _buildRow("Fecha de Inseminación", fechaInseminacion),
                            _buildRow("Inicio del Celo", fechaCelo),
                            _buildRow("N° de Crías Esperadas", numeroCrias),
                            _buildRow("Embarazo Confirmado", embarazoConfirmado),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, Object value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value.toString())),
        ],
      ),
    );
  }
}
