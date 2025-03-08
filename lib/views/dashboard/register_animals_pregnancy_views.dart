import 'package:ecuaranch/controllers/register_animals_pregnancy_controller.dart';
import 'package:ecuaranch/model/create_pregnancy.dart';
import 'package:flutter/material.dart';

class AddPregnancyAnimalScreen extends StatefulWidget {
  @override
  _AddPregnancyAnimalScreenState createState() => _AddPregnancyAnimalScreenState();
}

class _AddPregnancyAnimalScreenState extends State<AddPregnancyAnimalScreen> {
  final _animalIdController = TextEditingController();
  final _inseminationDateController = TextEditingController();
  final _pregnancyStatusController = TextEditingController();
  final _expectedBirthDateController = TextEditingController();
  final AnimalPregnancyController _animalPregnancyController = AnimalPregnancyController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Animal Pregnancy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _animalIdController,
              decoration: const InputDecoration(labelText: 'Animal ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _inseminationDateController,
              decoration: const InputDecoration(labelText: 'Insemination Date'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _pregnancyStatusController,
              decoration: const InputDecoration(labelText: 'Pregnancy Status'),
            ),
            TextField(
              controller: _expectedBirthDateController,
              decoration: const InputDecoration(labelText: 'Expected Birth Date'),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final animalId = int.tryParse(_animalIdController.text); // Convertir a int
                final inseminationDate = _inseminationDateController.text;
                final pregnancyStatus = _pregnancyStatusController.text;
                final expectedBirthDate = _expectedBirthDateController.text;

                if (animalId != null && inseminationDate.isNotEmpty && pregnancyStatus.isNotEmpty && expectedBirthDate.isNotEmpty) {
                  bool success = await _animalPregnancyController.saveAnimalPregnancy(
                    animalId, inseminationDate, pregnancyStatus, expectedBirthDate);

                  if (success) {
                    Navigator.pop(
                      context,
                      AnimalPregnancy(
                        id: 0,
                        animalId: animalId,
                        inseminationDate: inseminationDate,
                        pregnancyStatus: pregnancyStatus,
                        expectedBirthDate: expectedBirthDate,
                      ),
                    );
                  } else {
                    // Si hubo un error, mostramos un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al guardar la información del embarazo del animal.')),
                    );
                  }
                } else {
                  // Si los datos no son válidos, mostramos un mensaje
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor ingrese datos válidos.')),
                  );
                }
              },
              child: const Text('Save Animal Pregnancy'),
            ),
          ],
        ),
      ),
    );
  }
}
