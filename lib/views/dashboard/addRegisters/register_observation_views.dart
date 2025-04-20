import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterObservationView extends StatefulWidget {
  final int animalId;

  const RegisterObservationView({super.key, required this.animalId});

  @override
  State<RegisterObservationView> createState() => _RegisterObservationViewState();
}

class _RegisterObservationViewState extends State<RegisterObservationView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _observacionController = TextEditingController();
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
      "x_studio_fecha_1": DateFormat('yyyy-MM-dd').format(_selectedDate),
      "x_name": _observacionController.text,
    };

    final url = Uri.parse("https://ecuaranch-backend.duckdns.org/create_observation_in_animal_odoo"); 

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Observación registrada")),
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
      appBar: AppBar(title: const Text("Registrar Observaciones")),
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

                    TextFormField(
                      controller: _observacionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Observación",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Campo requerido" : null,
                    ),
                    const SizedBox(height: 16),

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
