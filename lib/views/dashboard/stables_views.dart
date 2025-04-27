import 'package:ecuaranch/controllers/dashboard/stables_controller.dart';
import 'package:ecuaranch/views/dashboard/animals_stable_id_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StablesView extends StatefulWidget {
  const StablesView({super.key});

  @override
  _StablesViewState createState() => _StablesViewState();
}

class _StablesViewState extends State<StablesView> {
  @override
  void initState() {
    super.initState();
    _loadStables();
  }

  Future<void> _loadStables() async {
    await context.read<StablesController>().fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    const buttonColor = Color(0xFF0A5A57); // Color del fondo del botón "Ver animales asignados"
    const addButtonColor = Color(0xFFFF5722); // Naranja para el botón de agregar
    const cardBackgroundColor = Color(0xFFF4F4F4); // Color de fondo para los cards

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
            'Listado de Establo',
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
        body: Consumer<StablesController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty) {
              return Center(child: Text(controller.errorMessage));
            }

            if (controller.stables.isEmpty) {
              return const Center(
                child: Text(
                  "No se encontraron establos.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _loadStables,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.stables.length,
                itemBuilder: (context, index) {
                  final stable = controller.stables[index];
                  final name = stable['x_name'] ?? 'Sin nombre';
                  final description =
                      stable['x_studio_related_field_80n_1io3dj80a'] ??
                          'Sin descripción';

                  return Card(
                    elevation: 8, // Mayor elevación para dar más profundidad
                    margin: const EdgeInsets.symmetric(vertical: 12), // Más espacio vertical
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Bordes más redondeados
                    ),
                    color: cardBackgroundColor, // Color de fondo del card
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // Más espacio dentro del card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor, // Fondo del botón verde oscuro
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Mejor tamaño del botón
                              ),
                              onPressed: () {
                                final stableId = stable['id'] ?? 0;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AnimalsByStableView(
                                      stableId: stableId,
                                      db: 'ecuaRanch', // reemplaza según tu flujo
                                      userId: 2, // puedes obtenerlo de AuthProvider
                                      password: 'gabriel@nextgensolutions.group', 
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Ver animales asignados",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white, // Texto del botón en blanco
                                ),
                              ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Acción para el botón de agregar
          },
          backgroundColor: addButtonColor, // Color naranja
          child: const Icon(Icons.add, color: Colors.white), // Ícono de agregar
        ),
      ),
    );
  }
}
