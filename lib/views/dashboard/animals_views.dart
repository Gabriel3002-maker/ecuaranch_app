import 'dart:convert';
import 'package:ecuaranch/controllers/dashboard/animals_controller.dart';
import 'package:ecuaranch/views/dashboard/addRegisters/register_info_views.dart';
import 'package:ecuaranch/views/dashboard/animal_detail_by_id_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/settings.dart';

class AnimalsView extends StatefulWidget {
  const AnimalsView({super.key});

  @override
  _AnimalsViewState createState() => _AnimalsViewState();
}

class _AnimalsViewState extends State<AnimalsView> {
  @override
  void initState() {
    super.initState();
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    await context.read<AnimalsController>().fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF6B8E23); // Verde oliva
    const cardBackgroundColor = Color(0xFFF4F4F4);
    const buttonColor = Color(0xFF0A5A57); // Color de botones

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/dashboard');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Animales Registrados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Consumer<AnimalsController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty) {
              return Center(child: Text(controller.errorMessage));
            }

            if (controller.animals.isEmpty) {
              return const Center(child: Text("No se encontraron animales"));
            }

            return RefreshIndicator(
              onRefresh: _loadAnimals,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.animals.length,
                itemBuilder: (context, index) {
                  var animal = controller.animals[index];

                  String base64Image = animal['x_studio_image'] ?? '';
                  ImageProvider? imageProvider;

                  if (base64Image.isNotEmpty) {
                    try {
                      imageProvider = MemoryImage(base64Decode(base64Image));
                    } catch (e) {
                      imageProvider = null;
                    }
                  }

                  final int animalId = animal['id'] ?? 0;

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: cardBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: themeColor.withOpacity(0.1),
                            backgroundImage: imageProvider,
                            child: imageProvider == null
                                ? const Icon(Icons.pets, size: 30, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  animal['x_name'] ?? 'Sin nombre',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text('🐂 Género: ${animal['x_studio_genero'] ?? 'No disponible'}'),
                                Text('💰 Valor: ${animal['x_studio_value'] ?? 'No disponible'}'),
                                Text('❤️ Estado: ${animal['x_studio_estado_de_salud_1'] ?? 'No disponible'}'),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: buttonColor,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AnimalDetailByIdView(
                                                animalId: animalId,
                                                db: Config.databaseName,
                                                userId: Config.userId,
                                                password: Config.password,
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
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: buttonColor,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
