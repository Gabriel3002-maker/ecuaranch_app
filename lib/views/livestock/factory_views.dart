import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ecuaranch/controllers/livestock/get_factory_controller.dart';

class FactoryViews extends StatefulWidget {
  const FactoryViews({super.key});

  @override
  State<FactoryViews> createState() => _FactoryViewsState();
}

class _FactoryViewsState extends State<FactoryViews> {
  @override
  void initState() {
    super.initState();
    final controller = Provider.of<GetFactoryController>(context, listen: false);
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
        title: const Text('Órdenes de Fábrica'),
        centerTitle: true,
      ),
      body: Consumer<GetFactoryController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text('Error: ${controller.errorMessage}'));
          } else if (controller.factory.isEmpty) {
            return const Center(child: Text('No hay órdenes disponibles.'));
          }

          return ListView.builder(
            itemCount: controller.factory.length,
            itemBuilder: (context, index) {
              final order = controller.factory[index];

              final name = order['name'] ?? 'Sin número';
              final product = (order['product_id'] != null && order['product_id'].length > 1)
                  ? order['product_id'][1]
                  : 'Producto desconocido';
              final qty = order['product_qty']?.toString() ?? '0';
              final unit = (order['product_uom_id'] != null && order['product_uom_id'].length > 1)
                  ? order['product_uom_id'][1]
                  : 'unidad';
              final state = order['state'] ?? 'Estado desconocido';
              final start = formatDateTime(order['date_start']);
              final end = formatDateTime(order['date_finished']);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.cabin, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(child: Text('Producto: $product')),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.numbers, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text('Cantidad: $qty $unit'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.flag, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text('Estado: $state'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(child: Text('Inicio: $start')),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.schedule_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(child: Text('Fin: $end')),
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
