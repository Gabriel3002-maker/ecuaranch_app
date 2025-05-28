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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStables();
    });
  }

  Future<void> _loadStables() async {
    await context.read<StablesController>().fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    const buttonColor = Color(0xFF0A5A57);
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
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Listado de Establo',
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
        body: Consumer<StablesController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.errorMessage,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadStables,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
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
                  final name = stable.name ?? 'Sin nombre';

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
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              onPressed: () {
                                final stableId = stable.id ?? 0;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AnimalsByStableView(
                                      stableId: stableId,
                                      db: 'ecuaRanch',
                                      userId: 2,
                                      password: 'gabriel@nextgensolutions.group',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Ver animales asignados",
                                style: TextStyle(fontSize: 16, color: Colors.white),
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
            Navigator.pushNamed(context, '/create-stables');
          },
          backgroundColor: Colors.orange,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
