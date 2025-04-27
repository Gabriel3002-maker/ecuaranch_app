import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color themeColor = Color(0xFF0A5A57);

class RegisterProductionView extends StatefulWidget {
  final int animalId;

  const RegisterProductionView({super.key, required this.animalId});

  @override
  State<RegisterProductionView> createState() => _RegisterProductionViewState();
}

class _RegisterProductionViewState extends State<RegisterProductionView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _litrosController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  // Datos fijos
  final String db = "ecuaRanch";
  final int userId = 2;
  final String password = "gabriel@nextgensolutions.group";

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final body = {
      "db": db,
      "user_id": userId,
      "password": password,
      "x_registrar_animal_id": widget.animalId,
      "x_studio_fecha": DateFormat('yyyy-MM-dd').format(_selectedDate),
      "x_studio_litros_producidos": int.tryParse(_litrosController.text) ?? 0,
      "x_name": _comentarioController.text,
    };

    final url = Uri.parse("https://ecuaranch-backend.duckdns.org/create_production"); 

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Producción registrada correctamente")),
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
          backgroundColor: Colors.white, // Fondo blanco en el AppBar
          automaticallyImplyLeading: false, // Desactivar el botón de retroceso automático
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black), // Ícono de retroceso negro
            onPressed: () {
              Navigator.pop(context); // Botón de retroceso
            },
          ),
          title: const Text(
            'Registrar Produccion',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold, // Texto en negrita
              color: Colors.black, // Texto en color negro
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black), // Ícono de notificaciones negro
              onPressed: () {
                // Acción de notificaciones
              },
            ),
          ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text("Animal ID: ${widget.animalId}"),
                    const SizedBox(height: 16),

                    // Ingreso de litros producidos
                    TextFormField(
                      controller: _litrosController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Litros producidos",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo requerido";
                        }
                        if (int.tryParse(value) == null) {
                          return "Debe ser un número";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Comentario
                    TextFormField(
                      controller: _comentarioController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Comentario",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Campo requerido" : null,
                    ),
                    const SizedBox(height: 16),

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
                          child: const Text("Seleccionar fecha",
                          style: TextStyle(color: themeColor),),
                        ),
                      ],
                    ),
                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style:ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),

                        ),
                        onPressed: _submitForm,
                        child: const Text("Registrar",
                        style:  TextStyle(color: Colors.white
                        ),
                        ) ,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
