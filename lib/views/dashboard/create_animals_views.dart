import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ecuaranch/controllers/dashboard/create_animals_controller.dart';
import 'package:provider/provider.dart';
import 'package:ecuaranch/dto/animalCreateDTO.dart';
import 'package:ecuaranch/controllers/image_controller.dart';

import '../../model/person.dart';
import '../../services/services.dart';

class AnimalRegistrationScreen extends StatefulWidget {
  const AnimalRegistrationScreen({super.key});

  @override
  State<AnimalRegistrationScreen> createState() => _AnimalRegistrationScreenState();
}

class _AnimalRegistrationScreenState extends State<AnimalRegistrationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _dbController = TextEditingController();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _xNameController = TextEditingController();
  final _xStudioPartnerIdController = TextEditingController();
  final _xStudioAlimentacionInicial1Controller = TextEditingController();
  final _xStudioPesoInicialController = TextEditingController();
  final _xStudioDateStartController = TextEditingController();
  final _xStudioGenero1Controller = TextEditingController();
  final _xStudioCharField18c1io38ib86Controller = TextEditingController();
  final _xStudioDestinadoAController = TextEditingController();
  final _xStudioEstadoDeSalud1Controller = TextEditingController();
  final _xStudioUserIdController = TextEditingController();
  final _xStudioValueController = TextEditingController();

  String? _selectedAlimentacion;
  String? _selectedGenero;
  String? _selectedDestinadoa;
  String? _selectedEstadoSalud;

  List<Person> _persons = [];
  Person? _selectedPerson;  // Cambié esto para almacenar un objeto completo Person

  String? _base64Image;


  @override
  void initState() {
    super.initState();
    _loadPersons();
  }

  Future<void> _loadPersons() async {
    try {
      final persons = await OdooService.fetchPersons();
      setState(() {
        _persons = persons;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al cargar personas")),
      );
    }
  }

  Future<void> _pickImage() async {
    final imageController = ImageController();
    final base64Image = await imageController.pickImageAsBase64();
    setState(() {
      _base64Image = base64Image;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage++);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage--);
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    final controller = context.read<CreateAnimalsController>();

    final animalDto = AnimalDto(
      db: _dbController.text,
      userId: int.tryParse(_userIdController.text) ?? 0,
      password: _passwordController.text,
      xName: _xNameController.text,
      xStudioPartnerId: _xStudioPartnerIdController.text,
      xStudioAlimentacionInicial1: _xStudioAlimentacionInicial1Controller.text,
      xStudioPesoInicial: double.tryParse(_xStudioPesoInicialController.text) ?? 0.0,
      xStudioDateStart: _xStudioDateStartController.text,
      xStudioGenero1: _xStudioGenero1Controller.text,
      xStudioCharField18c1io38ib86: _xStudioCharField18c1io38ib86Controller.text,
      xStudioDestinadoA: _xStudioDestinadoAController.text,
      xStudioEstadoDeSalud1: _xStudioEstadoDeSalud1Controller.text,
      xStudioUserId: _xStudioUserIdController.text,
      xStudioValue: double.tryParse(_xStudioValueController.text) ?? 0.0,
      xStudioImage: _base64Image ?? '',
    );

    await controller.createAnimal(animalDto);

    if (controller.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(controller.errorMessage)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Animal registrado exitosamente')));
      _clearForm();
      Navigator.pop(context);
    }
  }

  void _clearForm() {
    _dbController.clear();
    _userIdController.clear();
    _passwordController.clear();
    _xNameController.clear();
    _xStudioPartnerIdController.clear();
    _xStudioAlimentacionInicial1Controller.clear();
    _xStudioPesoInicialController.clear();
    _xStudioDateStartController.clear();
    _xStudioGenero1Controller.clear();
    _xStudioCharField18c1io38ib86Controller.clear();
    _xStudioDestinadoAController.clear();
    _xStudioEstadoDeSalud1Controller.clear();
    _xStudioUserIdController.clear();
    _xStudioValueController.clear();
    _selectedAlimentacion = null;
    _selectedGenero = null;
    _selectedDestinadoa = null;
    _selectedEstadoSalud = null;
    _selectedPerson = null; // Limpiar la persona seleccionada
    setState(() {});
  }

  Widget _buildPage(List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(children: fields),
    );
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF0A5A57);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Registrar Animal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        
      ),
      body: Consumer<CreateAnimalsController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              LinearProgressIndicator(
                value: (_currentPage + 1) / 3,
                backgroundColor: Colors.grey[300],
                color: themeColor,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildPage([
                      const Text('Datos del Animal',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextField(
                        controller: _xNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.pets),
                        ),
                      ),
                      // Dropdown para seleccionar Persona
                      DropdownButtonFormField<Person>(
                        value: _selectedPerson, // La variable _selectedPerson almacena la persona seleccionada
                        items: _persons.map((person) {
                          return DropdownMenuItem<Person>(
                            value: person,
                            child: Text(person.name), // Mostramos el nombre de la persona en el Dropdown
                          );
                        }).toList(),
                        onChanged: (person) {
                          setState(() {
                            _selectedPerson = person; // Guardamos la persona seleccionada
                            _xStudioPartnerIdController.text = person?.id.toString() ?? ''; // Asignamos el id
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Seleccione Persona'),
                        validator: (value) => value == null ? 'Seleccione una persona' : null,
                      ),

                      // Dropdown: Alimentación Inicial
                      DropdownButtonFormField<String>(
                        value: _selectedAlimentacion,
                        decoration: const InputDecoration(
                          labelText: 'Alimentación Inicial',
                          prefixIcon: Icon(Icons.fastfood),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Leche', child: Text('Leche')),
                          DropdownMenuItem(value: 'Pasto', child: Text('Pasto')),
                          DropdownMenuItem(value: 'Balanceado', child: Text('Balanceado')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedAlimentacion = value;
                            _xStudioAlimentacionInicial1Controller.text = value!;
                          });
                        },
                      ),
                      TextField(
                        controller: _xStudioPesoInicialController,
                        decoration: const InputDecoration(
                          labelText: 'Peso Inicial',
                          prefixIcon: Icon(Icons.fitness_center),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: _xStudioDateStartController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha de Inicio',
                          prefixIcon: Icon(Icons.date_range),
                        ),
                      ),
                      // Dropdown: Género
                      DropdownButtonFormField<String>(
                        value: _selectedGenero,
                        decoration: const InputDecoration(
                          labelText: 'Género',
                          prefixIcon: Icon(Icons.transgender),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Macho', child: Text('Macho')),
                          DropdownMenuItem(value: 'Hembra', child: Text('Hembra')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGenero = value;
                            _xStudioGenero1Controller.text = value!;
                          });
                        },
                      ),
                      // Tomar foto
                      const SizedBox(height: 10),
                      if (_base64Image != null)
                        Image.memory(
                          base64Decode(_base64Image!),
                          height: 150,
                        ),
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Tomar Foto de la Vaca"),
                      ),
                    ]),
                    _buildPage([
                      const Text('Salud y Estado',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextField(
                        controller: _xStudioCharField18c1io38ib86Controller,
                        decoration: const InputDecoration(
                          labelText: 'Código de Identificación',
                          prefixIcon: Icon(Icons.code),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedDestinadoa,
                        decoration: const InputDecoration(
                          labelText: 'Destinado A:',
                          prefixIcon: Icon(Icons.assignment),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Leche', child: Text('Leche')),
                          DropdownMenuItem(value: 'Carne', child: Text('Carne')),
                          DropdownMenuItem(value: 'Semental', child: Text('Semental')),
                          DropdownMenuItem(value: 'Reproductora', child: Text('Reproductora')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedDestinadoa = value;
                            _xStudioDestinadoAController.text = value!;
                          });
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedEstadoSalud,
                        decoration: const InputDecoration(
                          labelText: 'Estado de Salud',
                          prefixIcon: Icon(Icons.health_and_safety),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Optima', child: Text('Optima')),
                          DropdownMenuItem(value: 'Moderado', child: Text('Moderado')),
                          DropdownMenuItem(value: 'Desnutricion', child: Text('Desnutrición')),
                          DropdownMenuItem(value: 'Grave', child: Text('Grave')),
                          DropdownMenuItem(value: 'Recuperacion', child: Text('Recuperación')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedEstadoSalud = value;
                            _xStudioEstadoDeSalud1Controller.text = value!;
                          });
                        },
                      ),
                      DropdownButtonFormField<Person>(
                        value: _selectedPerson, // La variable _selectedPerson almacena la persona seleccionada
                        items: _persons.map((person) {
                          return DropdownMenuItem<Person>(
                            value: person,
                            child: Text(person.name), // Mostramos el nombre de la persona en el Dropdown
                          );
                        }).toList(),
                        onChanged: (person) {
                          setState(() {
                            _selectedPerson = person; // Guardamos la persona seleccionada
                            // Aquí asignamos el id de la persona al _xStudioPartnerIdController
                            _xStudioUserIdController.text = person?.id.toString() ?? ''; // Asignamos el id
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Seleccione Persona'),
                        validator: (value) => value == null ? 'Seleccione una persona' : null,
                      ),

                      TextField(
                        controller: _xStudioValueController,
                        decoration: const InputDecoration(
                          labelText: 'Valor',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      ElevatedButton(
                        onPressed: _previousPage,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        child: const Text('Atrás'),
                      ),
                    controller.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _currentPage < 2
                          ? _nextPage
                          : () => _submitForm(context),
                      style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                      child: Text(_currentPage < 2 ? 'Siguiente' : 'Registrar'),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
