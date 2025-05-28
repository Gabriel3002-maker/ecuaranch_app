import 'package:ecuaranch/controllers/dashboard/weight_alert_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/settings.dart';
import 'animal_detail_by_id_views.dart';

class WeightAlertViews extends StatefulWidget {
  const WeightAlertViews({super.key});

  @override
  _WeightAlertViewsState createState() => _WeightAlertViewsState();
}

class _WeightAlertViewsState extends State<WeightAlertViews> {
  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    await context.read<WeightAlertController>().fetchUserData();
  }

  void _showAlertActionDialog(BuildContext context, int alertId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar acción"),
        content: Text("¿Deseas tomar acción sobre la alerta con ID: $alertId?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Cierra el diálogo

              // Delay the showing of the SnackBar to ensure context is stable
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Acción ejecutada para la alerta")),
                );
              });

              try {
                // Llamamos al controlador para tomar la acción sobre la alerta
                await context.read<WeightAlertController>().takeActionOnAlert(alertId);

                // Si se ejecutó correctamente, mostramos el mensaje de éxito
                final controller = context.read<WeightAlertController>();
                if (controller.errorMessage.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(controller.errorMessage)),
                    );
                  });
                }

              } catch (e) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                });
              }
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const buttonColor = Color(0xFF0A5A57);
    const addButtonColor = Color(0xFFFF5722);
    const cardBackgroundColor = Color(0xFFF4F4F4);

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
            'Alertas de Peso',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
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
              child: IgnorePointer(
                child: Center(
                  child: Opacity(
                    opacity: 0.06,
                    child: Image.asset(
                      'assets/images/logoecuaranch.png',
                      width: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            // Contenido de las alertas
            Consumer<WeightAlertController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage));
                }

                if (controller.weight.isEmpty) {
                  return const Center(
                    child: Text(
                      "No se encontraron alertas de peso.",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadAlerts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.weight.length,
                    itemBuilder: (context, index) {
                      final alert = controller.weight[index];
                      final alertId = alert['id'];
                      final alertName = alert['x_name'] ?? 'Sin nombre';
                      final animalData = alert['x_studio_animal'] is List<dynamic>
                          ? alert['x_studio_animal'] as List<dynamic>
                          : [];
                      final animalName = animalData.length > 1 ? animalData[1] : 'Animal desconocido';
                      final alertDate = alert['x_studio_fecha'] ?? 'Fecha no disponible';
                      final diffWeight = alert['x_studio_diferencia_de_peso']?.toString() ?? '0';
                      final currentWeight = alert['x_studio_peso_actual']?.toString() ?? '0';
                      final previousWeight = alert['x_studio_peso_anterior']?.toString() ?? '0';

                      final animalId = animalData.isNotEmpty ? animalData[0] : null;

                      return Card(
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: cardBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.monitor_weight, color: Colors.deepOrange),
                                title: Text(
                                  alertName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    Text("Animal: $animalName"),
                                    Text("Fecha: $alertDate"),
                                    const SizedBox(height: 8),
                                    Text("Peso actual: $currentWeight kg"),
                                    Text("Peso anterior: $previousWeight kg"),
                                    Text("Diferencia de peso: $diffWeight kg"),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.pan_tool, color: Colors.blue),
                                      tooltip: "Tomar acción",
                                      onPressed: () => _showAlertActionDialog(context, alertId),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.pets, color: Colors.green),
                                      tooltip: "Ver detalles del animal",
                                      onPressed: () {
                                        if (animalId != null) {
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
                                        }
                                      },
                                    ),
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
          ],
        ),
      ),
    );
  }
}

