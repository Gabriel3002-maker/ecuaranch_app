import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../settings/settings.dart';

class RegisterFeedingView extends StatefulWidget {
  final int animalId;

  const RegisterFeedingView({super.key, required this.animalId});

  @override
  State<RegisterFeedingView> createState() => _RegisterFeedingViewState();
}

const Color themeColor = Color(0xFF0A5A57); // Verde temático

class _RegisterFeedingViewState extends State<RegisterFeedingView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _alimentoController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  final String db = Config.databaseName;
  final int userId = Config.userId;
  final String password = Config.password;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final body = {
      "db": db,
      "user_id": userId,
      "password": password,
      "x_registrar_animal_id": widget.animalId,
      "x_studio_fecha": DateFormat('yyyy-MM-dd').format(_selectedDate),
      "x_name": _alimentoController.text,
    };

    const url = Config.baseUrl;
    final url2 = Uri.parse("$url/create_feeding_animal_line");
    try {
      final response = await http.post(
        url2,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Alimentación registrada correctamente")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error: ${response.body}")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error de red: $e")),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Registrar Alimentación',
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
              // Acción futura
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo con el logo con opacidad
          Positioned.fill(
            child: IgnorePointer(  // Evita que el fondo interfiera con la interacción
              child: Center(
                child: Opacity(
                  opacity: 0.06,  // Opacidad baja
                  child: Image.asset(
                    'assets/images/logoecuaranch.png',  // Ruta de la imagen
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          // Cuerpo principal con el formulario
          Padding(
            padding: const EdgeInsets.all(16),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Form(
              key: _formKey,
              child: Column(
                children: [
                  //Text("Animal ID: ${widget.animalId}"),
                  //const SizedBox(height: 16),
                  // Fecha
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Fecha: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}",
                        ),
                      ),
                      TextButton(
                        onPressed: _pickDate,
                        child: const Text(
                          "Seleccionar fecha",
                          style: TextStyle(color: themeColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),


                  // Campo de texto
                  TextFormField(
                    controller: _alimentoController,
                    decoration: const InputDecoration(
                      labelText: "Nombre del alimento",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Requerido" : null,
                  ),
                  const Spacer(),

                  // Botón registrar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _submitForm,
                      child: const Text(
                        "Registrar",
                        style: TextStyle(color: Colors.white),
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
