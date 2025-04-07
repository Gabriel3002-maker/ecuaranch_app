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
            color: Colors.white, // Color blanco para el texto
          ),
        ),
        backgroundColor: const Color(0xFF6B8E23), // Verde oliva para el AppBar
      ),
      body: Stack(
        children: [
          // Imagen de fondo que ocupa toda la pantalla
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                'assets/images/campo_ganadero.png',  // Asegúrate de tener esta imagen en los assets
                width: MediaQuery.of(context).size.width, // Ajusta el ancho a la pantalla
                height: MediaQuery.of(context).size.height, // Ajusta la altura a la pantalla
              ),
            ),
          ),
          // Contenido centrado en la pantalla
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'dashboard.welcome'.tr(),  // Traducción de "Welcome to the Dashboard!"
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto blanco
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Contenedor que utiliza el espacio disponible para centrar los botones
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          // Botón "Add Animal"
                          MouseRegion(
                            onEnter: (_) {
                              // Cambia el color cuando el mouse entra en el área
                              // Aquí lo podrías hacer si tienes un efecto de hover.
                            },
                            onExit: (_) {
                              // Restaura el color cuando el mouse sale del área
                            },
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/add-animal');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                backgroundColor: const Color(0xFF6B8E23),
                                textStyle: const TextStyle(fontSize: 18), // Botón verde
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'dashboard.addAnimal'.tr(),  // Traducción de "Add Animal"
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Botón "Add Animal Weight"
                          MouseRegion(
                            onEnter: (_) {
                              // Cambiar el color a naranja cuando el mouse pasa por encima
                            },
                            onExit: (_) {
                              // Restaurar el color cuando el mouse sale
                            },
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/add-animal-weight');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                backgroundColor: const Color(0xFF6B8E23),
                                textStyle: const TextStyle(fontSize: 18), // Botón verde
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'dashboard.addAnimalWeight'.tr(),  // Traducción de "Add Animal Weight"
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Botón "Add Animal Pregnancy"
                          MouseRegion(
                            onEnter: (_) {
                              // Cambiar el color a naranja cuando el mouse pasa por encima
                            },
                            onExit: (_) {
                              // Restaurar el color cuando el mouse sale
                            },
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/add-animal-pregnancy');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                backgroundColor: const Color(0xFF6B8E23),
                                textStyle: const TextStyle(fontSize: 18), // Botón verde
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'dashboard.addAnimalPregnancy'.tr(),  // Traducción de "Add Animal - Pregnancy"
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Botón "List Animals"
                          MouseRegion(
                            onEnter: (_) {
                              // Cambiar el color a naranja cuando el mouse pasa por encima
                            },
                            onExit: (_) {
                              // Restaurar el color cuando el mouse sale
                            },
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/list-animal');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                backgroundColor: const Color(0xFF6B8E23),
                                textStyle: const TextStyle(fontSize: 18), // Botón verde
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'dashboard.listAnimals'.tr(),  // Traducción de "List Animals"
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Botón "Logout"
                          MouseRegion(
                            onEnter: (_) {
                              // Cambiar el color a naranja cuando el mouse pasa por encima
                            },
                            onExit: (_) {
                              // Restaurar el color cuando el mouse sale
                            },
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                backgroundColor: const Color(0xFF6B8E23),
                                textStyle: const TextStyle(fontSize: 18), // Botón verde
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'dashboard.logout'.tr(),  // Traducción de "Logout"
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
