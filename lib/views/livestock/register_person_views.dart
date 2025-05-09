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
      appBar: AppBar(title: const Text('Registrar Persona')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor ingrese el nombre' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor ingrese el email' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(labelText: 'Móvil'),
              ),
              const SizedBox(height: 10),
              if (imageBytes != null)
                Image.memory(imageBytes, height: 150)
              else
                const Text("No hay imagen seleccionada"),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Tomar o seleccionar foto"),
              ),
              const SizedBox(height: 20),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
