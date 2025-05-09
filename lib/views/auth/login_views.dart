import 'package:ecuaranch/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dashboard/main_tab_views.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF0A5A57);
    const labelColor = Color(0xFFA2A2A7);

    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logoecuaranch.png",
                  height: 120,
                ),
              ),
              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'Usuario',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Contraseña',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              Consumer<UserController>(
                builder: (context, controller, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: controller.isLoading
                          ? null
                          : () async {
                              controller.setUsername(usernameController.text);
                              controller.setPassword(passwordController.text);

                              await controller.fetchUserData();

                              if (controller.userData != null &&
                                  controller.userData?['status'] == 'success') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MainTabScreen(),
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
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text("Aceptar"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                      child: controller.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
