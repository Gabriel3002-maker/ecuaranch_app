import 'package:ecuaranch/controllers/auth/auth_controller.dart';
import 'package:ecuaranch/views/dashboard/dashboard_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(0xFF6D4C41); 

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/campo_ganadero.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Consumer<UserController>(
                    builder: (context, controller, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo o ícono
                          Icon(Icons.agriculture, size: 60, color: themeColor),
                          const SizedBox(height: 10),
                          Text(
                            "Bienvenido a Ecuaranch",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Usuario',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: controller.setUsername,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            onChanged: controller.setPassword,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: controller.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2,
                                    )
                                  : const Icon(Icons.login , color: Colors.white,),
                              label: Text(
                                controller.isLoading ? '' : 'Iniciar sesión',
                                style: const TextStyle(fontSize: 16,   color: Colors.white ),
                                
                              ),
                              onPressed: controller.isLoading
                                  ? null
                                  : () async {
                                      await controller.fetchUserData();

                                      if (controller.userData != null &&
                                          controller.userData?['status'] == 'success') {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const DashboardScreen(),
                                          ),
                                        );
                                      } else if (controller.errorMessage != null) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text("Error"),
                                            content: Text(controller.errorMessage!),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Aceptar"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
