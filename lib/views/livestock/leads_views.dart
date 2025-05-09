import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecuaranch/controllers/livestock/get_leads_controller.dart';

class LeadsViews extends StatefulWidget {
  const LeadsViews({super.key});

  @override
  State<LeadsViews> createState() => _LeadsViewsState();
}

class _LeadsViewsState extends State<LeadsViews> {
  @override
  void initState() {
    super.initState();
    final controller = Provider.of<GetLeadsController>(context, listen: false);
    controller.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oportunidades'),
        centerTitle: true,
      ),
      body: Consumer<GetLeadsController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text('Error: ${controller.errorMessage}'));
          } else if (controller.leads.isEmpty) {
            return const Center(child: Text('No hay oportunidades disponibles.'));
          }

          return ListView.builder(
            itemCount: controller.leads.length,
            itemBuilder: (context, index) {
              final lead = controller.leads[index];

              final name = lead['name'] ?? 'Sin nombre';
              final email = lead['email_from'] ?? 'Sin correo';
              final phone = lead['phone'] ?? 'Sin teléfono';
              final mobile = lead['mobile'] ?? 'Sin móvil';
              final stage = lead['stage_id'] != null && lead['stage_id'].length > 1
                  ? lead['stage_id'][1]
                  : 'Etapa desconocida';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.mail, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(child: Text(email)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(phone),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.smartphone, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(mobile),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.flag, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text('Etapa: $stage'),
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
