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
    final themeColor = const Color(0xFF6B8E23); // Verde oliva

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/dashboard');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Establos'),
          backgroundColor: themeColor,
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
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: themeColor,
                              child:
                                  const Icon(Icons.home, color: Colors.white),
                            ),
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
                                backgroundColor: themeColor,
                              ),
                              onPressed: () {
                                final stableId = stable['id'] ?? 0;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AnimalsByStableView(
                                      stableId: stableId,
                                      db: 'ecuaRanch', // reemplaza según tu flujo
                                      userId:
                                          2, // puedes obtenerlo de AuthProvider
                                      password: 'gabriel@nextgensolutions.group', 
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Ver animales asignados"),
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
          onPressed: _loadStables,
          backgroundColor: themeColor,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
