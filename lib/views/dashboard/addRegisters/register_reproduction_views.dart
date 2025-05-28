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

  PageController _pageController = PageController();

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

    const url = Config.baseUrl;
    final url2 = Uri.parse("$url/create_reproduction_followup_animal_in_odoo");

    try {
      final response = await http.post(
        url2,
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

  // This is the correct definition of _pickDate
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
          'Etapas de Reproduccion',
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
          // Cuerpo principal con las secciones de formulario
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    // Página 1: Fechas
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                                  child: const Text("Seleccionar fecha", style: TextStyle(color: themeColor)),
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
                                  child: const Text("Seleccionar fecha", style: TextStyle(color: themeColor)),
                                ),
                              ],
                            ),
                            const Spacer(),

                            // Botón para ir a la siguiente sección
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                                child: const Text("Siguiente"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Página 2: Métodos y confirmación
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Método de reproducción
                            DropdownButtonFormField<String>(
                              value: _methodOfReproduction,
                              items: const [
                                DropdownMenuItem(child: Text("Inseminacion"), value: "Inseminacion"),
                                DropdownMenuItem(child: Text("Cubricion Natural"), value: "Natural"),
                              ],
                              onChanged: (value) => setState(() => _methodOfReproduction = value!),
                              decoration: const InputDecoration(
                                labelText: "Metodo de reproduccion",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Confirmación de embarazo
                            DropdownButtonFormField<String>(
                              value: _confirmationOfPregnancy,
                              items: const [
                                DropdownMenuItem(child: Text("Ecografia"), value: "Ecografia"),
                                DropdownMenuItem(child: Text("Examen Veterinario"), value: "Examen veterinario"),
                              ],
                              onChanged: (value) => setState(() => _confirmationOfPregnancy = value!),
                              decoration: const InputDecoration(
                                labelText: "Confirmacion de embarazo",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Embarazo confirmado
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
                            const Spacer(),

                            // Botón para ir a la siguiente sección
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                                child: const Text("Siguiente"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Página 3: Número de crías y duración
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Número de crías esperadas
                            TextFormField(
                              controller: _expectedOffspringController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Número de crías esperadas",
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

                            // Duración del celo
                            TextFormField(
                              controller: _durationController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Duración del celo (en días)",
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
                            const Spacer(),

                            // Botón para registrar la reproducción
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                                onPressed: _submitForm,
                                child: const Text("Registrar Reproducción"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
