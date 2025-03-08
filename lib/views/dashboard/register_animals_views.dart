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
      appBar: AppBar(title: const Text('Add Animal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Animal Name'),
            ),
            TextField(
              controller: _speciesController,
              decoration: const InputDecoration(labelText: 'Animal Species'),
            ),
            const SizedBox(height: 20),
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
                }
              },
              child: const Text('Save Animal'),
            ),
          ],
        ),
      ),
    );
  }
}
