import 'package:ecuaranch/model/create_animal.dart';
import 'package:flutter/material.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  _AnimalListScreenState createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  List<Animal> animals = [];  

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
                        // Puedes agregar más detalles, como la edad o el peso
                        Text('Age: ${animal.name} years', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          animals.removeAt(index); // Eliminar el animal de la lista
                        });
                      },
                    ),
                    onTap: () {
                      // Puedes agregar una acción al hacer tap, por ejemplo, ir a una pantalla de detalles
                    },
                  ),
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
        backgroundColor: const Color(0xFF6B8E23),
        child: const Icon(Icons.add),
      ),
    );
  }
}
