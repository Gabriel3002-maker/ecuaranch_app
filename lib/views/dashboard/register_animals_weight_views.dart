import 'package:ecuaranch/controllers/register_animals_weight_controller.dart';
import 'package:ecuaranch/model/create_weight.dart';
import 'package:flutter/material.dart';

class AddWeightAnimalScreen extends StatefulWidget {
  @override
  _AddWeightAnimalScreenState createState() => _AddWeightAnimalScreenState();
}

class _AddWeightAnimalScreenState extends State<AddWeightAnimalScreen> {
  final _nameIdController = TextEditingController();
  final _dateController = TextEditingController();
  final _weightController = TextEditingController();
  final AnimalWeightController _animalweightController = AnimalWeightController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Animal Weight')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameIdController,
              decoration: const InputDecoration(labelText: 'Animal ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final nameId = int.tryParse(_nameIdController.text); 
                final date = _dateController.text;
                final weight = double.tryParse(_weightController.text); 

                // Validación de los datos
                if (nameId != null && date.isNotEmpty && weight != null) {
                  bool success = await _animalweightController.saveAnimalWeight(nameId, date, weight);

                  if (success) {
                    Navigator.pop(
                      context,
                      AnimalWeight(animalId: nameId, date: date, weight: weight),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al guardar el peso del animal.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor ingrese datos válidos.')),
                  );
                }
              },
              child: const Text('Save Animal Weight'),
            ),
          ],
        ),
      ),
    );
  }
}
