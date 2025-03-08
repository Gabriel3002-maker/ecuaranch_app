
import 'package:ecuaranch/model/create_animal.dart';
import 'package:flutter/material.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  _AnimalListScreenState createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  List<Animal> animals = [];  // Lista para almacenar animales

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal List'),
      ),
      body: animals.isEmpty
          ? const Center(child: Text('No animals added yet!'))
          : ListView.builder(
              itemCount: animals.length,
              itemBuilder: (context, index) {
                final animal = animals[index];
                return ListTile(
                  title: Text(animal.name),
                  subtitle: Text(animal.specie),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add').then((newAnimal) {
            if (newAnimal != null) {
              setState(() {
                animals.add(newAnimal as Animal);
              });
            }
          });
        },
        child: const  Icon(Icons.add),
      ),
    );
  }
}
