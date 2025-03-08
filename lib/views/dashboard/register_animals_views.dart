import 'package:ecuaranch/controllers/register_animals_controller.dart';
import 'package:ecuaranch/model/create_animal.dart';
import 'package:flutter/material.dart';

class AddAnimalScreen extends StatefulWidget {
  @override
  _AddAnimalScreenState createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final RegisterAnimalsController _animalController = RegisterAnimalsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Animal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B8E23), // Verde oliva para el AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(
                controller: _nameController,
                labelText: 'Animal Name',
                icon: Icons.pets,
              ),
              _buildTextField(
                controller: _speciesController,
                labelText: 'Animal Species',
                icon: Icons.assignment,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final name = _nameController.text;
                  final species = _speciesController.text;

                  if (name.isNotEmpty && species.isNotEmpty) {
                    // Llamamos al controlador para crear el animal
                    bool success = await _animalController.createAnimal(name, species);

                    // Si la creación fue exitosa, regresamos al anterior
                    if (success) {
                      Navigator.pop(context, Animal(name: name, specie: species));
                    } else {
                      // Si hubo un error, mostramos un mensaje de error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error al crear el animal.')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in both fields')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B8E23), // Color verde oliva
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Save Animal',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir el TextField con estilo
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF6B8E23)), // Verde oliva para el texto
          prefixIcon: Icon(icon, color: const Color(0xFF6B8E23)), // Icono verde oliva
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF6B8E23), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF6B8E23), width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFBDB76B), width: 2), // Beige
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
