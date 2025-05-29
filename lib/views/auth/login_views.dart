import 'package:ecuaranch/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dashboard/main_tab_views.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false; // Variable para manejar la visibilidad de la contraseña

  final usernameController = TextEditingController(); // Mantén el controlador para el usuario
  final passwordController = TextEditingController(); // Mantén el controlador para la contraseña

  @override
  void dispose() {
    // Asegúrate de limpiar los controladores cuando se cierre la pantalla
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF0A5A57);
    const labelColor = Color(0xFFA2A2A7);

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
                controller: usernameController, // No hay cambio aquí
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
                controller: passwordController, // Mantén el controlador para la contraseña
                obscureText: !_isPasswordVisible, // Cambiar la visibilidad de la contraseña
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off, // Cambia entre visibilidad y ocultación
                      color: labelColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible; // Alterna la visibilidad
                      });
                    },
                  ),
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

                        // Verifica si la respuesta es válida
                        if (controller.userData != null &&
                            controller.userData?['status'] == 'success' &&
                            controller.userData?['user_id'] != false &&
                            controller.userData?['user_id'] != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const MainTabScreen(),
                            ),
                          );
                        } else if (controller.userData?['user_id'] == false ||
                            controller.userData?['user_id'] == null) {
                          // Usuario o contraseña incorrectos
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Usuario o contraseña incorrectos."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (controller.errorMessage != null) {
                          // Otro tipo de error (por ejemplo, conexión)
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Error"),
                              content: Text(controller.errorMessage!),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
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
