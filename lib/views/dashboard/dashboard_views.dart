import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';  // Asegúrate de importar easy_localization

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'dashboard.dashboard'.tr(),  // Traducción de "Dashboard"
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFF6B8E23), // Verde oliva para el AppBar
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6B8E23), Color(0xFF98FB98)], // Gradiente de verde
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF6B8E23), // Fondo verde para el encabezado
                ),
                child: Text(
                  'Menu', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.white),
                title: Text(
                  'dashboard.addAnimal'.tr(),  // Traducción de "Add Animal"
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add-animal');
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_chart, color: Colors.white),
                title: Text(
                  'dashboard.addAnimalWeight'.tr(),  // Traducción de "Add Animal - Weight"
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add-animal-weight');
                },
              ),
              ListTile(
                leading: const Icon(Icons.pregnant_woman, color: Colors.white),
                title: Text(
                  'dashboard.addAnimalPregnancy'.tr(),  // Traducción de "Add Animal - Pregnancy"
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add-animal-pregancy');
                },
              ),
              ListTile(
                leading: const Icon(Icons.list, color: Colors.white),
                title: Text(
                  'dashboard.listAnimals'.tr(),  // Traducción de "List the Animals"
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/list-animal');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: Text(
                  'dashboard.logout'.tr(),  // Traducción de "Logout"
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fondo con la imagen (cambia el nombre de la imagen según lo tengas)
          Positioned.fill(
            child: Image.asset(
              'assets/images/campo_ganadero.png',  // Asegúrate de tener esta imagen en los assets
              fit: BoxFit.cover,
            ),
          ),
          // Fondo oscuro para mejorar la visibilidad del texto
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Filtro oscuro
            ),
          ),
          // Contenido de la pantalla centrado
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'dashboard.welcome',  // Traducción de "Welcome to the Dashboard!"
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Color blanco para el texto
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
