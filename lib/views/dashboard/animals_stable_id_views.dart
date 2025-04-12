import 'dart:convert';
import 'dart:typed_data';
import 'package:ecuaranch/controllers/dashboard/animals_stable_id_controller.dart';
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
    const themeColor = Color(0xFF6B8E23);

    return ChangeNotifierProvider(
      create: (_) => AnimalsStableIdController()
        ..fetchAnimals(
          db: db,
          userId: userId,
          password: password,
          stableId: stableId,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Animales asignados"),
          backgroundColor: themeColor,
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
                final String gender =
                    animal['x_studio_genero_1'] ?? 'Sin género';
                final String use = animal['x_studio_destinado_a'] ?? 'Sin uso';
                final String createDate =
                    animal['create_date'] ?? 'Fecha no disponible';
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
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: image != null
                              ? CircleAvatar(
                                  backgroundImage: image,
                                  backgroundColor: themeColor.withOpacity(0.2),
                                )
                              : CircleAvatar(
                                  backgroundColor: themeColor.withOpacity(0.2),
                                  child: const Icon(Icons.image,
                                      color: Colors.white),
                                ),
                          title: Text(name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Género: $gender"),
                              Text("Uso: $use"),
                              Text("Fecha creación: $createDate"),
                              Text("Valor: ${value.toString()}"),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AnimalDetailByIdView(
                                    animalId: animal['id'], 
                                    db: db,
                                    userId: userId,
                                    password: password,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Ver más detalles"),
                          ),
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
