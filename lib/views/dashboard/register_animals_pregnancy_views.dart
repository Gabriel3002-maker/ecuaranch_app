import 'package:ecuaranch/controllers/register_animals_pregnancy_controller.dart';
import 'package:ecuaranch/model/create_pregnancy.dart';
import 'package:flutter/material.dart';

class AddPregnancyAnimalScreen extends StatefulWidget {
  @override
  _AddPregnancyAnimalScreenState createState() =>
      _AddPregnancyAnimalScreenState();
}

class _AddPregnancyAnimalScreenState extends State<AddPregnancyAnimalScreen> {
  final _animalIdController = TextEditingController();
  final _inseminationDateController = TextEditingController();
  final _pregnancyStatusController = TextEditingController();
  final _expectedBirthDateController = TextEditingController();
  final AnimalPregnancyController _animalPregnancyController =
      AnimalPregnancyController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Animal Pregnancy',
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
                controller: _animalIdController,
                labelText: 'Animal ID',
                keyboardType: TextInputType.number,
                icon: Icons.pets,
              ),
              _buildTextField(
                controller: _inseminationDateController,
                labelText: 'Insemination Date',
                keyboardType: TextInputType.datetime,
                icon: Icons.date_range,
              ),
              _buildTextField(
                controller: _pregnancyStatusController,
                labelText: 'Pregnancy Status',
                icon: Icons.medical_services,
              ),
              _buildTextField(
                controller: _expectedBirthDateController,
                labelText: 'Expected Birth Date',
                keyboardType: TextInputType.datetime,
                icon: Icons.date_range,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final animalId = int.tryParse(_animalIdController.text); // Convertir a int
                  final inseminationDate = _inseminationDateController.text;
                  final pregnancyStatus = _pregnancyStatusController.text;
                  final expectedBirthDate = _expectedBirthDateController.text;

                  if (animalId != null &&
                      inseminationDate.isNotEmpty &&
                      pregnancyStatus.isNotEmpty &&
                      expectedBirthDate.isNotEmpty) {
                    bool success = await _animalPregnancyController
                        .saveAnimalPregnancy(animalId, inseminationDate,
                            pregnancyStatus, expectedBirthDate);

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
                        const SnackBar(content: Text(
                            'Error al guardar la información del embarazo del animal.')),
                      );
                    }
                  } else {
                    // Si los datos no son válidos, mostramos un mensaje
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor ingrese datos válidos.')),
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
                  'Save Animal Pregnancy',
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
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color(0xFF6B8E23), // Verde oliva para las etiquetas
          ),
          prefixIcon: Icon(icon, color: Color(0xFF6B8E23)), // Íconos verdes
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFF6B8E23), // Verde oliva cuando está enfocado
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFBDB76B), // Beige claro
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: keyboardType ?? TextInputType.text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
