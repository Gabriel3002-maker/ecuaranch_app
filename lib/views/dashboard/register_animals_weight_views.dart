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
      appBar: AppBar(
        title: const Text(
          'Add Animal Weight',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
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
                controller: _nameIdController,
                labelText: 'Animal ID',
                icon: Icons.pets,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _dateController,
                labelText: 'Date',
                icon: Icons.date_range,
                keyboardType: TextInputType.datetime,
              ),
              _buildTextField(
                controller: _weightController,
                labelText: 'Weight',
                icon: Icons.monitor_weight,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 30),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B8E23), // Color verde oliva
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Save Animal Weight',
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
    required TextInputType keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
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
