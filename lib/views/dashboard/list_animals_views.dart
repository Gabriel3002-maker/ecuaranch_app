import 'package:ecuaranch/controllers/get_animals_list_controller.dart';
import 'package:ecuaranch/dto/animalDto.dart';
import 'package:ecuaranch/views/dashboard/list_animals_pregnancies.dart';
import 'package:ecuaranch/views/dashboard/list_animals_weight.dart';
import 'package:flutter/material.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  _AnimalListScreenState createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  List<AnimalDTO> animals = [];
  final GetAnimalsController _getAnimalsController = GetAnimalsController();

  @override
  void initState() {
    super.initState();
    _fetchAnimals();
  }

  // Fetch the list of animals from the controller
  Future<void> _fetchAnimals() async {
    await _getAnimalsController.getListAnimals();
    setState(() {
      animals = _getAnimalsController.animals; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animal List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFF6B8E23),
      ),
      body: animals.isEmpty
          ? const Center(child: Text('No animals added yet!'))
          : ListView.builder(
              itemCount: animals.length,
              itemBuilder: (context, index) {
                final animal = animals[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.pets,
                      color: Color(0xFF6B8E23),
                    ),
                    title: Text(
                      animal.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Species: ${animal.specie}', style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        // Puedes agregar más detalles, como la edad
                        Text('Age: ${animal.specie} years', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'viewPregnancies') {
                          // Navegar a la vista de embarazos
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PregnanciesScreen(animalId: animal.id),
                            ),
                          );
                        } else if (value == 'viewWeight') {
                          // Navegar a la vista de peso
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeightScreen(animalId: animal.id),
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: 'viewPregnancies',
                          child: Text('View Pregnancies'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'viewWeight',
                          child: Text('View Weight'),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Puedes agregar cualquier otra acción al hacer tap
                    },
                  ),
                );
              },
            ),
    );
  }
}
