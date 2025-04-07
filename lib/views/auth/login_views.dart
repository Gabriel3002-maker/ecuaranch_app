import 'package:ecuaranch/controllers/auth/auth_controller.dart';
import 'package:ecuaranch/views/dashboard/dashboard_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login - Odoo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserController>(
          builder: (context, controller, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Usuario'),
                  onChanged: controller.setUsername,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  onChanged: controller.setPassword,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : () async {
                          // Llamamos al controlador para autenticar al usuario
                          await controller.fetchUserData();

                          // Si la respuesta es exitosa
                          if (controller.userData != null &&
                              controller.userData?['status'] == 'success') {
                            // Navegar al DashboardScreen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashboardScreen(),
                              ),
                            );
                          } else if (controller.errorMessage != null) {
                            // Si ocurre un error, mostrar un mensaje
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Error"),
                                content: Text(controller.errorMessage!),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Aceptar"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                  child: controller.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Iniciar sesión'),
                ),
                SizedBox(height: 20),
                if (controller.isLoading)
                  Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}
