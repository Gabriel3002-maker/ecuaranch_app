import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecuaranch/views/livestock/register_person_views.dart';
import 'package:ecuaranch/model/create_stable.dart';
import 'package:ecuaranch/services/services.dart';
import 'package:ecuaranch/settings/settings.dart';
import '../../controllers/image_controller.dart';
import '../../model/person.dart';

class RegisterStableView extends StatefulWidget {
  const RegisterStableView({super.key});

  @override
  State<RegisterStableView> createState() => _RegisterStableViewState();
}

class _RegisterStableViewState extends State<RegisterStableView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final ImageController _imageController = ImageController();

  String? _base64Image;
  DateTime _selectedDate = DateTime(2024, 1, 12);
  bool _isSending = false;

  List<Person> _persons = [];
  Person? _selectedPerson;

  @override
  void initState() {
    super.initState();
    _loadPersons();
  }

  Future<void> _loadPersons() async {
    try {
      final persons = await OdooService.fetchUsers();
      setState(() {
        _persons = persons;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al cargar personas")),
      );
    }
  }

  Future<void> _takePhoto() async {
    final imageBase64 = await _imageController.pickImageAsBase64();
    if (imageBase64 != null) {
      setState(() {
        _base64Image = imageBase64;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _clearForm() {
    _nameController.clear();
    setState(() {
      _selectedPerson = null;
      _base64Image = null;
      _selectedDate = DateTime(2024, 1, 12);
    });
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate() || _base64Image == null || _selectedPerson == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    setState(() => _isSending = true);

    final stableData = StableData(
      db: Config.databaseName,
      userId: Config.userId,
      password: Config.password,
      xName: _nameController.text,
      xStudioDate: _selectedDate.toIso8601String(),
      xStudioPartnerId: _selectedPerson!.partnerIdValue!,
      xStudioImage: _base64Image!,
    );

    final success = await OdooService.createStable(stableData);

    setState(() => _isSending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Enviado con éxito" : "Error al enviar")),
    );

    if (success) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  InputDecoration _customInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF0A5A57),
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF0A5A57), width: 3),
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes = _base64Image != null ? base64Decode(_base64Image!) : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Registrar Establo",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.06,
              child: Image.asset(
                'assets/icons/Logo@300x.png',
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: _customInputDecoration('Nombre'),
                    validator: (value) => value == null || value.isEmpty ? 'Ingrese un nombre' : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<Person>(
                    value: _selectedPerson,
                    decoration: _customInputDecoration('Persona Encargada'),
                    items: _persons.map((person) {
                      return DropdownMenuItem(
                        value: person,
                        child: Text(person.name),
                      );
                    }).toList(),
                    onChanged: (person) => setState(() => _selectedPerson = person),
                    validator: (value) => value == null ? 'Seleccione una persona' : null,
                  ),
                  const SizedBox(height: 10),

                  if (_selectedPerson == null)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPersonView()));
                      },
                      child: const Text('Registrar nueva persona'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A5A57),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(_selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _pickDate,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text("Tomar Foto", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A5A57),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (imageBytes != null)
                    Image.memory(imageBytes, height: 150)
                  else
                    const Text("No hay imagen seleccionada", textAlign: TextAlign.center),

                  const SizedBox(height: 20),

                  _isSending
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _base64Image != null ? _submitData : null,
                    child: const Text("Enviar", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A5A57),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
