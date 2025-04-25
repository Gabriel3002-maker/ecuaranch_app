import 'dart:convert';
import 'package:ecuaranch/controllers/dashboard/animals_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final themeColor = const Color(0xFF6B8E23); // Verde oliva

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/dashboard');
        return false;
      },
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
            'Animales Registrados',
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

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Aquí podrías navegar a una vista de detalles
                                      // Navigator.pushNamed(context, '/animal-detail', arguments: animal);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Detalles de ${animal['x_name'] ?? 'el animal'}')),
                                      );
                                    },
                                    icon: const Icon(Icons.info_outline),
                                    label: const Text("Detalles"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: themeColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
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
