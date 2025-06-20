import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../settings/settings.dart';

class RegisterReproductionView extends StatefulWidget {
  final int animalId;

  const RegisterReproductionView({super.key, required this.animalId});

  @override
  State<RegisterReproductionView> createState() => _RegisterReproductionViewState();
}

const Color themeColor = Color(0xFF0A5A57);

class _RegisterReproductionViewState extends State<RegisterReproductionView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _expectedOffspringController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  DateTime _celOStartDate = DateTime.now();
  DateTime _inseminationDate = DateTime.now();
  bool _isLoading = false;

  final String db = Config.databaseName;
  final int userId = Config.userId;
  final String password = Config.password;

  String _methodOfReproduction = "Inseminacion";
  String _confirmationOfPregnancy = "Ecografia";
  String _pregnancyConfirmed = "Si";

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final body = {
      "db": db,
      "user_id": userId,
      "password": password,
      "x_registrar_animal_id": widget.animalId,
      "x_studio_fecha_de_inicio_del_celo": DateFormat('yyyy-MM-dd').format(_celOStartDate),
      "x_studio_fecha_de_inseminacin": DateFormat('yyyy-MM-dd').format(_inseminationDate),
      "x_studio_metodo_de_reproduccion": _methodOfReproduction,
      "x_name": _durationController.text,
      "x_studio_confirmacin_de_embarazo_1": _confirmationOfPregnancy,
      "x_studio_embarazo_confirmado": _pregnancyConfirmed,
      "x_studio_nmero_de_cras_esperadas": int.tryParse(_expectedOffspringController.text) ?? 0,
    };

    final url = Uri.parse("https://ecuaranch-backend.duckdns.org/create_reproduction_followup_animal_in_odoo");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Reproduccion registrada correctamente")),
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

  Future<void> _pickDate(DateTime initialDate, Function(DateTime) setDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => setDate(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Registrar Etapas de Reproduccion',
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

                    // Fecha inicio del celo
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Fecha inicio del celo: ${DateFormat('yyyy-MM-dd').format(_celOStartDate)}",
                          ),
                        ),
                        TextButton(
                          onPressed: () => _pickDate(_celOStartDate, (date) => _celOStartDate = date),
                          child: const Text(
                            "Seleccionar fecha",
                            style: TextStyle(color: themeColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Fecha de inseminación
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Fecha inseminacion: ${DateFormat('yyyy-MM-dd').format(_inseminationDate)}",
                          ),
                        ),
                        TextButton(
                          onPressed: () => _pickDate(_inseminationDate, (date) => _inseminationDate = date),
                          child: const Text(
                            "Seleccionar fecha",
                            style: TextStyle(color: themeColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _methodOfReproduction,
                      items: const [
                        DropdownMenuItem(child: Text("Inseminacion"), value: "Inseminacion"),
                        DropdownMenuItem(child: Text("Cubricion Natural"), value: "Cubricion Natural"),
                      ],
                      onChanged: (value) => setState(() => _methodOfReproduction = value!),
                      decoration: const InputDecoration(
                        labelText: "Metodo de reproduccion",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _confirmationOfPregnancy,
                      items: const [
                        DropdownMenuItem(child: Text("Ecografia"), value: "Ecografia"),
                        DropdownMenuItem(child: Text("Examen Veterinario"), value: "Examen Veterinario"),
                      ],
                      onChanged: (value) => setState(() => _confirmationOfPregnancy = value!),
                      decoration: const InputDecoration(
                        labelText: "Confirmacion de embarazo",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _pregnancyConfirmed,
                      items: const [
                        DropdownMenuItem(child: Text("Si"), value: "Si"),
                        DropdownMenuItem(child: Text("No"), value: "No"),
                      ],
                      onChanged: (value) => setState(() => _pregnancyConfirmed = value!),
                      decoration: const InputDecoration(
                        labelText: "Embarazo confirmado",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _expectedOffspringController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Numero de crias esperadas",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo requerido";
                        }
                        if (int.tryParse(value) == null) {
                          return "Debe ser un numero";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Duracion del celo (en dias)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo requerido";
                        }
                        if (int.tryParse(value) == null) {
                          return "Debe ser un numero";
                        }
                        return null;
                      },
                    ),
                    const Spacer(),

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
    );
  }
}
