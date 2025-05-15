import 'dart:convert';  // Para Base64Decoder
import 'dart:typed_data'; // Para Uint8List

import 'package:ecuaranch/views/livestock/register_person_views.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      final persons = await OdooService.fetchPersons();
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

  // Método para limpiar el formulario
  void _clearForm() {
    _nameController.clear();
    setState(() {
      _selectedPerson = null;
      _base64Image = null;
      _selectedDate = DateTime(2024, 1, 12);  // Fecha predeterminada
    });
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate() || _base64Image == null || _selectedPerson == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    final stableData = StableData(
      db: Config.databaseName,
      userId: Config.userId,
      password: Config.password,
      xName: _nameController.text,
      xStudioDate: _selectedDate.toIso8601String(),
      xStudioPartnerId: _selectedPerson!.id,
      xStudioImage: _base64Image!,
    );

    final success = await OdooService.createStable(stableData);

    setState(() {
      _isSending = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Enviado con éxito" : "Error al enviar")),
    );

    if (success) {
      // Limpiar el formulario si se envió correctamente
      _clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Establo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo Nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Ingrese un nombre' : null,
              ),
              const SizedBox(height: 10),

              // Dropdown para seleccionar Persona
              DropdownButtonFormField<Person>(
                value: _selectedPerson,
                items: _persons.map((person) {
                  return DropdownMenuItem<Person>(
                    value: person,
                    child: Text(person.name),
                  );
                }).toList(),
                onChanged: (person) {
                  setState(() {
                    _selectedPerson = person;
                  });
                },
                decoration: const InputDecoration(labelText: 'Seleccione Persona'),
                validator: (value) => value == null ? 'Seleccione una persona' : null,
              ),
              const SizedBox(height: 10),

              // Botón para registrar nueva persona
              if (_selectedPerson == null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPersonView()),
                    );
                  },
                  child: const Text('Registrar nueva persona', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A5A57), // Color de fondo
                  ),
                ),
              const SizedBox(height: 10),

              // Selección de fecha
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
              const SizedBox(height: 10),

              // Mostrar imagen seleccionada o tomar foto
              _base64Image != null
                  ? Image.memory(
                Uint8List.fromList(Base64Decoder().convert(_base64Image!)),
                height: 150,
              )
                  : const Text("No hay imagen seleccionada"),

              // Botón para tomar foto
              ElevatedButton(
                onPressed: _takePhoto,
                child: const Text("Tomar Foto", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A5A57), // Color de fondo
                ),
              ),
              const SizedBox(height: 20),

              // Botón de enviar (solo habilitado si hay imagen seleccionada)
              ElevatedButton(
                onPressed: _base64Image == null || _isSending ? null : _submitData,
                child: _isSending
                    ? const CircularProgressIndicator()
                    : const Text("Enviar", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A5A57), // Color de fondo
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
