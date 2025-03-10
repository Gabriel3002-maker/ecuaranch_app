import 'package:easy_localization/easy_localization.dart';  
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/campo_ganadero.png', 
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), 
            ),
          ),
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
                  TextField(
                    style: const TextStyle(color: Colors.white), 
                    decoration: InputDecoration(
                      labelText: 'register.email'.tr(),  // Traducción del texto
                      labelStyle: const TextStyle(color: Colors.white), 
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6B8E23), width: 2),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDB76B), width: 2), // Beige
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    obscureText: _obscureTextPassword,
                    decoration: InputDecoration(
                      labelText: 'register.password'.tr(),  // Traducción del texto
                      labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6B8E23), width: 2),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDB76B), width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextPassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureTextPassword = !_obscureTextPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    obscureText: _obscureTextConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'register.confirmpassword'.tr(),  // Traducción del texto
                      labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6B8E23), width: 2),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDB76B), width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF6B8E23), 
                      backgroundColor: Colors.white, 
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    },
                    child: Text(
                      'register.register'.tr(),  // Traducción del texto
                      style: const TextStyle(fontSize: 18, color: Color(0xFF6B8E23)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text(
                      'register.alredyhaveaccount'.tr(),  
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 55, 147, 205),
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
