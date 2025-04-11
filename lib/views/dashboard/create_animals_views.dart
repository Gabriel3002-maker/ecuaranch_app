import 'package:ecuaranch/controllers/dashboard/create_animals_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecuaranch/dto/animalCreateDTO.dart';

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

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage++);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
  }

  Widget _buildPage(List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(children: fields),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF6B8E23); // Verde oliva

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Animal'),
        backgroundColor: themeColor,
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
                      const Text('Datos de Conexión', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      TextField(controller: _dbController, decoration: const InputDecoration(labelText: 'Base de datos')),
                      TextField(controller: _userIdController, decoration: const InputDecoration(labelText: 'User ID'), keyboardType: TextInputType.number),
                      TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
                    ]),
                    _buildPage([
                      const Text('Datos del Animal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      TextField(controller: _xNameController, decoration: const InputDecoration(labelText: 'Nombre')),
                      TextField(controller: _xStudioPartnerIdController, decoration: const InputDecoration(labelText: 'ID del Socio')),
                      TextField(controller: _xStudioAlimentacionInicial1Controller, decoration: const InputDecoration(labelText: 'Alimentación Inicial')),
                      TextField(controller: _xStudioPesoInicialController, decoration: const InputDecoration(labelText: 'Peso Inicial'), keyboardType: TextInputType.number),
                      TextField(controller: _xStudioDateStartController, decoration: const InputDecoration(labelText: 'Fecha de Inicio')),
                      TextField(controller: _xStudioGenero1Controller, decoration: const InputDecoration(labelText: 'Género')),
                    ]),
                    _buildPage([
                      const Text('Salud y Estado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      TextField(controller: _xStudioCharField18c1io38ib86Controller, decoration: const InputDecoration(labelText: 'Código de Identificación')),
                      TextField(controller: _xStudioDestinadoAController, decoration: const InputDecoration(labelText: 'Destinado A')),
                      TextField(controller: _xStudioEstadoDeSalud1Controller, decoration: const InputDecoration(labelText: 'Estado de Salud')),
                      TextField(controller: _xStudioUserIdController, decoration: const InputDecoration(labelText: 'ID Usuario')),
                      TextField(controller: _xStudioValueController, decoration: const InputDecoration(labelText: 'Valor'), keyboardType: TextInputType.number),
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
                            onPressed: _currentPage < 2 ? _nextPage : () => _submitForm(context),
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
