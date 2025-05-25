import 'dart:convert';
import 'dart:typed_data';
import 'package:ecuaranch/model/create_stable.dart';
import 'package:ecuaranch/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:ecuaranch/controllers/dashboard/create_animals_controller.dart';
import 'package:provider/provider.dart';
import 'package:ecuaranch/dto/animalCreateDTO.dart';

import '../../dto/StableCreateDTO.dart';
import '../../model/person.dart';
import '../../services/services.dart';
import 'package:intl/intl.dart'; // Paquete para manejar fechas

class AnimalRegistrationScreen extends StatefulWidget {
  const AnimalRegistrationScreen({super.key});

  @override
  State<AnimalRegistrationScreen> createState() =>
      _AnimalRegistrationScreenState();
}

class _AnimalRegistrationScreenState extends State<AnimalRegistrationScreen> {
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
  final _xStudioEstabloAlQuePerteneceController = TextEditingController();



  String? _selectedAlimentacion;
  String? _selectedGenero;
  String? _selectedDestinadoa;
  String? _selectedEstadoSalud;

  Stable? _selectedStable;


  List<Stable> _stables = [];

  List<Person> _persons = [];
  Person? _selectedPerson;
  Person? _selectedCodeAnimal;



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

      final stables = await OdooService().getStablesFromOdoo();
      setState(() {
        _stables = stables;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al cargar personas")),
      );
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    final controller = context.read<CreateAnimalsController>();

    final partnerId = int.tryParse(_xStudioPartnerIdController.text) ?? 0;  // Default to 0 if invalid
    final userId = int.tryParse(_xStudioUserIdController.text) ?? 0;  // Default to 0 if invalid

    final animalDto = AnimalDto(
      db: _dbController.text,
      userId: userId, // user_id as integer
      password: _passwordController.text,
      xName: _xNameController.text,
      xStudioPartnerId: partnerId, // partner_id passed as integer but converted to string in DTO
      xStudioAlimentacionInicial1: _xStudioAlimentacionInicial1Controller.text,
      xStudioPesoInicial: double.tryParse(_xStudioPesoInicialController.text) ?? 0.0,
      xStudioDateStart: _xStudioDateStartController.text,  // Should be formatted correctly
      xStudioGenero1: _xStudioGenero1Controller.text,
      xStudioCharField18c1io38ib86: _xStudioCharField18c1io38ib86Controller.text,
      xStudioDestinadoA: _xStudioDestinadoAController.text,
      xStudioEstadoDeSalud1: _xStudioEstadoDeSalud1Controller.text,
      xStudioUserId: userId,
      xStudioValue: _xStudioValueController.text,
      xStudioEstabloAlQuePertenece: _xStudioEstabloAlQuePerteneceController.text

    );

    await controller.createAnimal(animalDto);

    if (controller.errorMessage.isNotEmpty) {
      // Si hay un error, lo mostramos
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(controller.errorMessage)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Animal registrado exitosamente: ${controller.animalId}')),
      );

      _clearForm();
      Navigator.pushReplacementNamed(context, '/dashboard'); // Asegúrate de que la ruta '/dashboard' esté definida
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
    _selectedPerson = null;
    setState(() {});
  }

  // Method to pick and format date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      // Format the selected date to yyyy-MM-dd
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      _xStudioDateStartController.text = formattedDate;
    }
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
          'Registrar Informacion Adicional - Animal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<CreateAnimalsController>(
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Text(
                  'Datos del Animal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextField(
                  controller: _xNameController,
                  decoration: const InputDecoration(
                    labelText: 'Raza y Codigo Ingresados (COO - 001) ',
                    prefixIcon: Icon(Icons.pets),
                  ),
                ),
                // Dropdown para seleccionar Persona
                DropdownButtonFormField<Person>(
                  value: _selectedCodeAnimal,
                  items: _persons.map((person) {
                    return DropdownMenuItem<Person>(
                      value: person,
                      child: Text(person.name),
                    );
                  }).toList(),
                  onChanged: (person) {
                    setState(() {
                      _selectedCodeAnimal = person;
                      final id = person?.id.toString() ?? '';
                      _xStudioPartnerIdController.text = id;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Seleccione el Codigo'),
                ),


                DropdownButtonFormField<Stable>(

                  items: _stables.map((stable) {
                    return DropdownMenuItem<Stable>(
                      value: stable,
                      child: Text(stable.name),
                    );
                  }).toList(),
                  onChanged: (stable) {
                    setState(() {
                      _selectedStable = stable;
                      _xStudioEstabloAlQuePerteneceController.text = stable?.id.toString() ?? '';
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Establo al que pertenece',
                    prefixIcon: Icon(Icons.home_work),
                  ),
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
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _xStudioDateStartController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Inicio',
                        prefixIcon: Icon(Icons.date_range),
                      ),
                    ),
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
                const Text(
                  'Salud y Estado',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
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
                TextField(
                  controller: _xStudioValueController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                controller.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () async {
                    await _submitForm(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                  ),
                  child: const Text('Registrar', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

