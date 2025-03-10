import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';  

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
                      labelText: 'login.email'.tr(),  
                      labelStyle: const TextStyle(color: Colors.white), 
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6B8E23), width: 2),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDB76B), width: 2), 
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    style: const TextStyle(color: Colors.white), 
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'login.password'.tr(),  
                      labelStyle: const TextStyle(color: Colors.white), 
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6B8E23), width: 2),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDB76B), width: 2), 
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
                      foregroundColor: const Color(0xFF6B8E23), backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    },
                    child: Text(
                      'login.login'.tr(), 
                      style: const TextStyle(fontSize: 18, color: Color(0xFF6B8E23)), 
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'login.dont_have_account'.tr(),  
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
