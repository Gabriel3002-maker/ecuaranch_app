import 'package:ecuaranch/controllers/get_animals_list_controller.dart';
import 'package:ecuaranch/dto/animalWeightDto.dart';
import 'package:flutter/material.dart';

class WeightScreen extends StatefulWidget {
  final int animalId;
  const WeightScreen({super.key, required this.animalId});

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final GetAnimalsController _getAnimalsController = GetAnimalsController();
  List<AnimalWeightDTO> weights = [];

  @override
  void initState() {
    super.initState();
    _fetchWeight();
  }

  // Fetch the animal's weight data
  Future<void> _fetchWeight() async {
    await _getAnimalsController.getAnimalsWeightById(widget.animalId);
    setState(() {
      weights = _getAnimalsController.weights;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weight')),
      body: weights.isEmpty
          ? const Center(child: Text('No weight data available!'))
          : ListView.builder(
              itemCount: weights.length,
              itemBuilder: (context, index) {
                final weight = weights[index];
                return Card(
                  child: ListTile(
                    title: Text('Weight ID: ${weight.date}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Animal ID: ${weight.animalId}'),
                        Text('Date: ${weight.date}'),
                        Text('Weight: ${weight.weight} kg'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
