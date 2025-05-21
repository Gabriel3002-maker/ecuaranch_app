import 'dart:convert';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecuaranch/controllers/dashboard/animals_stable_id_controller.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_info_views.dart';
import 'package:ecuaranch/views/dashboard/animal_detail_by_id_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimalsByStableView extends StatelessWidget {
  final int stableId;
  final String db;
  final int userId;
  final String password;

  const AnimalsByStableView({
    super.key,
    required this.stableId,
    required this.db,
    required this.userId,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF6B8E23); // Verde oliva
    const cardBackgroundColor = Color(0xFFF4F4F4); // Color para los cards
    const buttonColor = Color(0xFF0A5A57); // Color de los botones

    return ChangeNotifierProvider(
      create: (_) => AnimalsStableIdController()
        ..fetchAnimals(
          db: db,
          userId: userId,
          password: password,
          stableId: stableId,
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
              'Establo ',
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
          body: Consumer<AnimalsStableIdController>(
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

              if (controller.animals.isEmpty) {
                return const Center(child: Text("No hay animales asignados."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.animals.length,
                itemBuilder: (context, index) {
                  final animal = controller.animals[index];

                  final String name = animal['display_name'] ?? 'No Consta';
                  final String gender = animal['x_studio_genero_1'] ?? 'Sin género';
                  final String use = animal['x_studio_destinado_a'] ?? 'Sin uso';
                  final String createDate = animal['create_date'] ?? 'Fecha no disponible';
                  final String? imageBase64 = animal['x_studio_image'];
                  final num value = animal['x_studio_value'] ?? 0;
                  final int animalId = animal['id'] ?? 0;

                  ImageProvider? image;
                  if (imageBase64 != null && imageBase64.isNotEmpty) {
                    try {
                      final Uint8List imageBytes = base64Decode(imageBase64);
                      image = MemoryImage(imageBytes);
                    } catch (e) {
                      image = null;
                    }
                  }

                  return Card(
                    color: cardBackgroundColor, // Fondo de los cards en gris claro
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Bordes redondeados
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Columna de la información del animal
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    image != null
                                        ? CircleAvatar(
                                            backgroundImage: image,
                                            backgroundColor: themeColor.withOpacity(0.2),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: themeColor.withOpacity(0.2),
                                            child: const Icon(Icons.image, color: Colors.white),
                                          ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text("Género: $gender"),
                                Text("Uso: $use"),
                                Text("Fecha creación: ${DateFormat('d \'de\' MMMM \'de\' y', 'es_ES').format(DateTime.parse(createDate))}"),
                                Text("Valor: ${value.toString()}"),
                              ],
                            ),
                          ),
                          
                          // Columna de los botones
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AnimalDetailByIdView(
                                        animalId: animalId,
                                        db: db,
                                        userId: userId,
                                        password: password,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.visibility, color: Colors.white),
                                label: const Text(
                                  "Detalles",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor, // Naranja para "Registrar información"
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterInfoView(animalId: animalId),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit, color: Colors.white),
                                label: const Text(
                                  "Registrar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
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
}
