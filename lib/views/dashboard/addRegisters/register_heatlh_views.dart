import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterHealthView extends StatefulWidget {
  final int animalId;

  const RegisterHealthView({super.key, required this.animalId});

  @override
  State<RegisterHealthView> createState() => _RegisterHealthViewState();
}

class _RegisterHealthViewState extends State<RegisterHealthView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descripcionController = TextEditingController();
  String _estadoSeleccionado = 'Bueno';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  // Datos fijos
  final String db = "ecuaRanch";
  final int userId = 2;
  final String password = "gabriel@nextgensolutions.group";

  final List<String> estadosSalud = ["Bueno", "Regular", "Grave"];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final body = {
      "db": db,
      "user_id": userId,
      "password": password,
      "x_registrar_animal_id": widget.animalId,
      "x_studio_fecha": DateFormat('yyyy-MM-dd').format(_selectedDate),
      "x_name": _descripcionController.text,
      "x_studio_estado_de_salud": _estadoSeleccionado,
    };

    final url = Uri.parse("https://ecuaranch-backend.duckdns.org/health_monitoring_animal_in_odoo"); 

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Salud registrada correctamente")),
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
      appBar: AppBar(title: const Text("Registrar Salud")),
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

                    // Descripción del problema
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        labelText: "Descripción del problema",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Requerido" : null,
                    ),
                    const SizedBox(height: 16),

                    // Estado de salud (Dropdown)
                    DropdownButtonFormField<String>(
                      value: _estadoSeleccionado,
                      items: estadosSalud
                          .map((estado) => DropdownMenuItem(
                                value: estado,
                                child: Text(estado),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _estadoSeleccionado = value!),
                      decoration: const InputDecoration(
                        labelText: "Estado de salud",
                        border: OutlineInputBorder(),
                      ),
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
                          child: const Text("Seleccionar fecha"),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Botón
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text("Registrar"),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
