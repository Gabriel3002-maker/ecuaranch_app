import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ecuaranch/controllers/livestock/get_expenses_controller.dart';

class ExpensesViews extends StatefulWidget {
  const ExpensesViews({super.key});

  @override
  State<ExpensesViews> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesViews> {
  @override
  void initState() {
    super.initState();
    final controller = Provider.of<GetExpensesController>(context, listen: false);
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
        title: const Text('Gastos'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Fondo con el logo con opacidad
          Positioned.fill(
            child: IgnorePointer(  // Evita que el fondo interfiera con la interacción
              child: Center(
                child: Opacity(
                  opacity: 0.06,  // Opacidad baja
                  child: Image.asset(
                    'assets/images/logoecuaranch.png',  // Ruta de la imagen
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          // Cuerpo principal con el Consumer
          Consumer<GetExpensesController>(
            builder: (context, controller, child) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text('Error: ${controller.errorMessage}'));
              } else if (controller.events.isEmpty) {
                return const Center(child: Text('No se han generado gastos.'));
              }

              return ListView.builder(
                itemCount: controller.events.length,
                itemBuilder: (context, index) {
                  final event = controller.events[index];

                  // Extracting fields from the event data
                  final name = event['name'] ?? 'Sin título';
                  final date = formatDateTime(event['date']);
                  final totalAmount = event['total_amount'] ?? 0.0;
                  final product = event['product_id']?[1] ?? 'Producto desconocido';
                  final currency = event['currency_id']?[1] ?? 'Moneda desconocida';
                  final state = event['state'] ?? 'Estado desconocido';

                  return Card(
                    margin: const EdgeInsets.all(12),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre del gasto
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis, // Evitar overflow
                            maxLines: 2, // Limitar a 2 líneas
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 6),
                              Expanded( // Asegura que el texto no se desborde
                                child: Text(
                                  'Fecha: $date',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1, // Evita que se desborde
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.attach_money, size: 16),
                              const SizedBox(width: 6),
                              Text('Monto: \$${totalAmount.toString()}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.local_shipping, size: 16),
                              const SizedBox(width: 6),
                              Text('Producto: $product'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.monetization_on, size: 16),
                              const SizedBox(width: 6),
                              Text('Moneda: $currency'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.check_circle_outline, size: 16),
                              const SizedBox(width: 6),
                              Text('Estado: $state'),
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
        ],
      ),
    );
  }
}
