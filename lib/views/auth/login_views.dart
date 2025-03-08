import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con la imagen (agrega tu propia imagen relacionada con ganadería)
          Positioned.fill(
            child: Image.asset(
              'assets/images/campo_ganadero.png',  // Cambia a la imagen que prefieras
              fit: BoxFit.cover,
            ),
          ),
          // Fondo con un filtro oscuro para mejorar la visibilidad del formulario
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Filtro oscuro
            ),
          ),
          // Formulario centrado sobre la imagen
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logoecuabyte.png', 
                    height: 120,
                  ),
                  const SizedBox(height: 40),
                  // Campo de texto para Email
                  const TextField(
                    style: TextStyle(color: Colors.white), // Color de texto blanco
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white), // Color de la etiqueta blanco
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6B8E23), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDB76B), width: 2), // Beige
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Campo de texto para Password
                  TextField(
                    style: const TextStyle(color: Colors.white), // Color de texto blanco
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white), // Color de la etiqueta blanco
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6B8E23), width: 2),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDB76B), width: 2), // Beige
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Botón de Login
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF6B8E23), backgroundColor: Colors.white, // Texto verde
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Color(0xFF6B8E23)), // Texto verde
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Botón de registro
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 55, 147, 205), // Verde oliva
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
