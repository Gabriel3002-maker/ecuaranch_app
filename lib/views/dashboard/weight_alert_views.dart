import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/dashboard/health_alert_controller.dart';

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
    await context.read<HealthAlertController>().fetchUserData();
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
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Acción ejecutada para alerta ID: $alertId")),
              );
              // Puedes llamar aquí al método del controlador si deseas
              // context.read<HealthAlertController>().tomarAccion(alertId);
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
        body: Consumer<HealthAlertController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty) {
              return Center(child: Text(controller.errorMessage));
            }

            if (controller.health.isEmpty) {
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
                itemCount: controller.health.length,
                itemBuilder: (context, index) {
                  final alert = controller.health[index];
                  final alertId = alert['id'];
                  final alertName = alert['x_name'] ?? 'Sin nombre';
                  final animalData = alert['x_studio_animal'] as List<dynamic>? ?? [];
                  final animalName = animalData.length > 1 ? animalData[1] : 'Animal desconocido';
                  final alertDate = alert['x_studio_fecha'] ?? 'Fecha no disponible';
                  final diffWeight = alert['x_studio_diferencia_de_peso']?.toString() ?? '0';
                  final currentWeight = alert['x_studio_peso_actual']?.toString() ?? '0';
                  final previousWeight = alert['x_studio_peso_anterior']?.toString() ?? '0';

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
                            trailing: IconButton(
                              icon: const Icon(Icons.pan_tool, color: Colors.blue),
                              tooltip: "Tomar acción",
                              onPressed: () => _showAlertActionDialog(context, alertId),
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
            // Acción para agregar una alerta
          },
          backgroundColor: addButtonColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
