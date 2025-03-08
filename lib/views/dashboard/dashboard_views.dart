import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Add Animal'),
              onTap: () {
                // Aquí puedes agregar la lógica para navegar a la pantalla de perfil
                Navigator.pop(context); // Cierra el Drawer
                Navigator.pushNamed(context, '/add-animal');
              },
            ),
              ListTile(
              title: const Text('Add Animal - Weight'),
              onTap: () {
                // Lógica para la pantalla de configuración
                Navigator.pop(context); // Cierra el Drawer
                Navigator.pushNamed(context, '/add-animal-weight');
              },
            ),
                 ListTile(
              title: const Text('Add Animal - Pregnancy'),
              onTap: () {
                // Lógica para la pantalla de configuración
                Navigator.pop(context); // Cierra el Drawer
                Navigator.pushNamed(context, '/add-animal-pregancy');
              },
            ),
            ListTile(
              title: const Text('List the Animals'),
              onTap: () {
                // Lógica para la pantalla de configuración
                Navigator.pop(context); // Cierra el Drawer
                Navigator.pushNamed(context, '/list-animal');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Lógica para hacer logout
                Navigator.pop(context); // Cierra el Drawer
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: const  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text('Welcome to the Dashboard!'),

          ],
        ),
      ),
    );
  }
}
