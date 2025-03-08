import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color(0xFF6B8E23), // Verde oliva para el AppBar
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
                title: const Text(
                  'Add Animal',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add-animal');
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_chart, color: Colors.white),
                title: const Text(
                  'Add Animal - Weight',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add-animal-weight');
                },
              ),
              ListTile(
                leading: const Icon(Icons.pregnant_woman, color: Colors.white),
                title: const Text(
                  'Add Animal - Pregnancy',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add-animal-pregancy');
                },
              ),
              ListTile(
                leading: const Icon(Icons.list, color: Colors.white),
                title: const Text(
                  'List the Animals',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/list-animal');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
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
                  'Welcome to the Dashboard!',
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
