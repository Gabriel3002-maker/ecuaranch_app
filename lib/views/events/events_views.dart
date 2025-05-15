import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../controllers/events/get_events_controller.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    final controller =
    Provider.of<GetEventsControllerController>(context, listen: false);
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
        title: const Text('Eventos'),
        centerTitle: true,
      ),
      body: Consumer<GetEventsControllerController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text('Error: ${controller.errorMessage}'));
          } else if (controller.events.isEmpty) {
            return const Center(child: Text('No hay eventos disponibles.'));
          }

          return Stack(
            children: [
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

              ListView.builder(
                itemCount: controller.events.length,
                itemBuilder: (context, index) {
                  final event = controller.events[index];

                  final name = event['name'] ?? 'Sin título';
                  final dateBegin = formatDateTime(event['date_begin']);
                  final dateEnd = formatDateTime(event['date_end']);
                  final location =
                      event['adress_inline'] ?? 'Ubicación no disponible';

                  return Card(
                    margin: const EdgeInsets.all(12),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '$dateBegin - $dateEnd',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  location,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
