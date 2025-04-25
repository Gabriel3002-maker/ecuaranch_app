import 'dart:convert';
import 'dart:typed_data';

import 'package:ecuaranch/views/dashboard/historic/feeding_views.dart';
import 'package:ecuaranch/views/dashboard/historic/grow_views.dart';
import 'package:ecuaranch/views/dashboard/historic/health_views.dart';
import 'package:ecuaranch/views/dashboard/historic/observation_views.dart';
import 'package:ecuaranch/views/dashboard/historic/production_views.dart';
import 'package:ecuaranch/views/dashboard/historic/reproduction_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecuaranch/controllers/dashboard/animal_detail_by_id_controller.dart';

class AnimalDetailByIdView extends StatelessWidget {
  final int animalId;
  final String db;
  final int userId;
  final String password;

  const AnimalDetailByIdView({
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
      create: (_) => AnimalByIdDetailController()
        ..fetchAnimalDetails(
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
            'Detalles',
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
        body: Consumer<AnimalByIdDetailController>(
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

            if (controller.animalDetails.isEmpty) {
              return const Center(child: Text("No se encontraron detalles del animal."));
            }

            final animal = controller.animalDetails;
            final String name = animal['display_name'] ?? 'No disponible';
            final String gender = animal['x_studio_genero_1'] ?? 'No disponible';
            final String use = animal['x_studio_destinado_a'] ?? 'No disponible';
            final String createDate = animal['create_date'] ?? 'No disponible';
            final String value = animal['x_studio_value']?.toString() ?? 'No disponible';
            final String? imageBase64 = animal['x_studio_image'];

            ImageProvider? image;
            if (imageBase64 != null && imageBase64.isNotEmpty) {
              try {
                final Uint8List imageBytes = base64Decode(imageBase64);
                image = MemoryImage(imageBytes);
              } catch (_) {
                image = null;
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Detalles del animal
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: const Color(0xFFF4F4F4), // Color de la tarjeta
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: themeColor.withOpacity(0.2),
                            backgroundImage: image,
                            child: image == null
                                ? const Icon(Icons.pets, size: 50, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(height: 30, thickness: 1.2),
                          _buildDetailRow("Género", gender),
                          _buildDetailRow("Uso", use),
                          _buildDetailRow("Fecha de creación", createDate),
                          _buildDetailRow("Valor", value),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Bloque de HISTORIAL
                  const Text("📊 Historial", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // Usamos Wrap en lugar de GridView para que los botones se ajusten automáticamente
                  Wrap(
                    spacing: 10, // Espacio horizontal entre los botones
                    runSpacing: 10, // Espacio vertical entre las filas
                    children: [
                      _dashboardButton(
                        label: 'Observacion',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => AnimalHistoryObservationView(
                                db: db,
                                userId: userId,
                                password: password,
                                animalId: animalId,
                              ),
                            ),
                          );
                        },
                      ),
                      _dashboardButton(
                        label: 'Salud',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => AnimalHistoryHealthView(
                                db: db,
                                userId: userId,
                                password: password,
                                animalId: animalId,
                              ),
                            ),
                          );
                        },
                      ),
                      _dashboardButton(
                        label: 'Peso y Crecimiento',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => AnimalHistoryGrowView(
                                db: db,
                                userId: userId,
                                password: password,
                                animalId: animalId,
                              ),
                            ),
                          );
                        },
                      ),
                      _dashboardButton(
                        label: 'Reproducción',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => AnimalHistoryReproductionView(
                                db: db,
                                userId: userId,
                                password: password,
                                animalId: animalId,
                              ),
                            ),
                          );
                        },
                      ),
                      _dashboardButton(
                        label: 'Alimentación',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => AnimalHistoryFeedingView(
                                db: db,
                                userId: userId,
                                password: password,
                                animalId: animalId,
                              ),
                            ),
                          );
                        },
                      ),
                      _dashboardButton(
                        label: 'Producción',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => AnimalHistoryProductionView(
                                db: db,
                                userId: userId,
                                password: password,
                                animalId: animalId,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _dashboardButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0A5A57), // Color de fondo
        foregroundColor: Colors.white,
        minimumSize: const Size(100, 48), // Tamaño mínimo más adecuado para el ajuste
        textStyle: const TextStyle(fontSize: 12), // Tamaño de texto ajustado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordes redondeados
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 8),
          Text(label), // Texto del botón
        ],
      ),
    );
  }
}
