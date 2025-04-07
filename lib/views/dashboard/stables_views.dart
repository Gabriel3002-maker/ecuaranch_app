import 'package:ecuaranch/controllers/dashboard/stables_controller.dart';
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
    return WillPopScope(
      onWillPop: () async {
        // Regresar solo al Dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
        return false; // Evitar que el usuario regrese a la pantalla anterior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Estables de Odoo'),
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
              return const Center(child: Text("No se encontraron estables"));
            }

            return ListView.builder(
              itemCount: controller.stables.length,
              itemBuilder: (context, index) {
                var stable = controller.stables[index];
                return ListTile(
                  title: Text(stable['x_name'] ?? 'No name'),
                  subtitle: Text(stable['x_studio_related_field_80n_1io3dj80a'] ?? 'No description'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
