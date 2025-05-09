import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ecuaranch/controllers/livestock/get_warehouses_controller.dart';

class WarehousesViews extends StatefulWidget {
  const WarehousesViews({super.key});

  @override
  State<WarehousesViews> createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehousesViews> {
  @override
  void initState() {
    super.initState();
    final controller = Provider.of<GetWarehousesController>(context, listen: false);
    controller.fetchUserData();
  }

  String formatDateTime(String? rawDate) {
    if (rawDate == null) return 'Fecha no disponible';
    final dateTime = DateTime.tryParse(rawDate);
    if (dateTime == null) return 'Formato inválido';
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Almacenes'),
        centerTitle: true,
      ),
      body: Consumer<GetWarehousesController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text('Error: ${controller.errorMessage}'));
          } else if (controller.warehouses.isEmpty) {
            return const Center(child: Text('No hay inventario disponible.'));
          }

          return ListView.builder(
            itemCount: controller.warehouses.length,
            itemBuilder: (context, index) {
              final item = controller.warehouses[index];

              final productName = item['product_id']?[1] ?? 'Producto desconocido';
              final locationName = item['location_id']?[1] ?? 'Ubicación desconocida';
              final quantity = item['quantity'] ?? 0;
              final available = item['available_quantity'] ?? 0;
              final inDate = formatDateTime(item['in_date']);
              final tracking = item['tracking'] ?? 'Sin seguimiento';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(child: Text('Ubicación: $locationName')),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.inventory_2, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text('Cantidad total: $quantity'),
                          const SizedBox(width: 20),
                          Text('Disponible: $available'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.date_range, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text('Ingreso: $inDate'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.qr_code_2, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text('Tracking: $tracking'),
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
    );
  }
}
