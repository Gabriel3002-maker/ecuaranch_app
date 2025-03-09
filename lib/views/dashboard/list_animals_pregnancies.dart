import 'package:ecuaranch/controllers/get_animals_list_controller.dart';
import 'package:ecuaranch/dto/animalPregnaciesDto.dart';
import 'package:flutter/material.dart';

class PregnanciesScreen extends StatefulWidget {
  final int animalId;
  const PregnanciesScreen({super.key, required this.animalId});

  @override
  _PregnanciesScreenState createState() => _PregnanciesScreenState();
}

class _PregnanciesScreenState extends State<PregnanciesScreen> {
  final GetAnimalsController _getAnimalsController = GetAnimalsController();
  List<AnimalPregnancyDTO> pregnancies = [];

  @override
  void initState() {
    super.initState();
    _fetchPregnancies();
  }

  // Fetch the animal's pregnancies
  Future<void> _fetchPregnancies() async {
    await _getAnimalsController.getAnimalPregnanciesById(widget.animalId);
    setState(() {
      pregnancies = _getAnimalsController.pregnancies; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pregnancies')),
      body: pregnancies.isEmpty
          ? const Center(child: Text('No pregnancies data available!'))
          : ListView.builder(
              itemCount: pregnancies.length,
              itemBuilder: (context, index) {
                final pregnancy = pregnancies[index];
                return Card(
                  child: ListTile(
                    title: Text('Pregnancy ID: ${pregnancy.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Insemination Date: ${pregnancy.inseminationDate ?? 'N/A'}'),
                        Text('Pregnancy Status: ${pregnancy.pregnancyStatus ?? 'N/A'}'),
                        Text('Expected Birth Date: ${pregnancy.expectedBirthDate ?? 'N/A'}'),
                        Text('Health Status: ${pregnancy.healthStatus ?? 'N/A'}'),
                        Text('Father Health Status: ${pregnancy.fatherHealthStatus ?? 'N/A'}'),
                        Text('Post-Birth Health Status: ${pregnancy.postBirthHealthStatus ?? 'N/A'}'),
                        Text('Cause of Death: ${pregnancy.causeOfDeath ?? 'N/A'}'),
                        Text('Post Birth Notes: ${pregnancy.postBirthNotes ?? 'N/A'}'),
                        Text('Veterinarian: ${pregnancy.vetName ?? 'N/A'}'),
                        Text('Vet Visit Date: ${pregnancy.vetVisitDate ?? 'N/A'}'),
                        Text('Extra Notes: ${pregnancy.extraNotes ?? 'N/A'}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
