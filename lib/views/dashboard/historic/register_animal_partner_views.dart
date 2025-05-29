import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecuaranch/model/partner.dart';
import 'package:ecuaranch/services/services.dart';
import 'package:ecuaranch/settings/settings.dart';

class RegisterAnimalPartnerViews extends StatefulWidget {
  const RegisterAnimalPartnerViews({super.key});

  @override
  RegisterAnimalPartnerViewsState createState() => RegisterAnimalPartnerViewsState();
}

class RegisterAnimalPartnerViewsState extends State<RegisterAnimalPartnerViews> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();

  String? _base64Image;
  bool _isSubmitting = false;

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

      final response = await OdooService.createPerson(partner);

      if (response is Map<String, dynamic>) {
        if (response['status'] == 'success' && response['partner_id'] != null && response['partner_id'].isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Animal Registrado con éxito")),
          );

          _formKey.currentState!.reset();
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _mobileController.clear();
          setState(() {
            _base64Image = null;
          });

          Navigator.pushReplacementNamed(context, '/create-animal');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al registrar Animal")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Respuesta inesperada del servidor")),
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
          'Registrar Animal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Imagen de fondo con baja opacidad
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
          // Formulario y contenido principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: _customInputDecoration('CODIGO - RAZA '),
                    validator: (value) => value == null || value.isEmpty ? 'Por favor ingrese el nombre' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    decoration: _customInputDecoration('Email de Persona Encargada '),
                    validator: (value) => value == null || value.isEmpty ? 'Por favor ingrese el email' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneController,
                    decoration: _customInputDecoration('Teléfono de Persona Encargada'),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _mobileController,
                    decoration: _customInputDecoration('Móvil de Persona Encargada'),
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 28, // Aumentamos el tamaño del ícono para mayor visibilidad
                      ),
                      label: const Text(
                        "Tomar o seleccionar foto",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16, // Aumentamos el tamaño de la fuente para mejor legibilidad
                          fontWeight: FontWeight.w600, // Un peso de fuente un poco más fuerte
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A5A57),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Ajustamos el padding para mejor balance
                        elevation: 5, // Añadimos un poco de sombra para darle más profundidad
                        shadowColor: Colors.black.withOpacity(0.3), // Ajustamos el color de la sombra
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (imageBytes != null)
                    Image.memory(imageBytes, height: 150)
                  else
                    const Text(
                      "No hay imagen seleccionada",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),

                  const SizedBox(height: 20),

                  _isSubmitting
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: (_base64Image != null &&
                        _nameController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty)
                        ? _submitForm
                        : null,
                    child: const Text(
                      'Registrar',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A5A57),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
