import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecuaranch/model/partner.dart';
import 'package:ecuaranch/services/services.dart';
import 'package:ecuaranch/settings/settings.dart';

class RegisterPersonView extends StatefulWidget {
  const RegisterPersonView({super.key});

  @override
  _RegisterPersonViewState createState() => _RegisterPersonViewState();
}

class _RegisterPersonViewState extends State<RegisterPersonView> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();

  String? _base64Image;
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera, // o ImageSource.gallery si prefieres galería
      maxWidth: 600,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _base64Image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos y selecciona una imagen")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final partner = Partner(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        mobile: _mobileController.text,
        imageBase64: _base64Image!,
        db: Config.databaseName,
        userId: Config.userId,
        password: Config.password,
      );

      final success = await OdooService.createPerson(partner);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Persona registrada con éxito")),
        );

        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _mobileController.clear();
        setState(() {
          _base64Image = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al registrar la persona")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes = _base64Image != null ? base64Decode(_base64Image!) : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Registrar Persona',
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logoecuaranch.png'), // Ruta de la imagen de fondo
            fit: BoxFit.none, // Hace que la imagen cubra toda la pantalla
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Botón para tomar foto en la parte superior
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt, color: Colors.white), // Icono blanco
                    label: const Text("Tomar o seleccionar foto", style: TextStyle(color: Colors.white)), // Texto blanco
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A5A57), // Color de fondo
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Si la imagen ha sido seleccionada, mostrar el formulario
                if (_base64Image != null) ...[
                  // Campo Nombre (Obligatorio)
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(color: Color(0xFF0A5A57)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Por favor ingrese el nombre' : null,
                  ),
                  const SizedBox(height: 16),

                  // Campo Email (Obligatorio)
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Color(0xFF0A5A57)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Por favor ingrese el email' : null,
                  ),
                  const SizedBox(height: 16),

                  // Campo Teléfono (Opcional)
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      labelStyle: TextStyle(color: Color(0xFF0A5A57)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo Móvil (Opcional)
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Móvil',
                      labelStyle: TextStyle(color: Color(0xFF0A5A57)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Imagen seleccionada o tomar foto
                  if (imageBytes != null)
                    Image.memory(imageBytes, height: 150)
                  else
                    const Text(
                      "No hay imagen seleccionada",
                      style: TextStyle(color: Colors.grey),
                    ),
                  const SizedBox(height: 20),

                  // Botón de registrar con color verde
                  _isSubmitting
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _base64Image != null && _nameController.text.isNotEmpty && _emailController.text.isNotEmpty
                        ? _submitForm
                        : null, // Solo habilitar si la imagen y los campos obligatorios están completos
                    child: const Text('Registrar', style: TextStyle(color: Colors.white)), // Texto blanco
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A5A57),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
