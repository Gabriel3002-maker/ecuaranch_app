import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';  // Importa easy_localization
import 'package:ecuaranch/views/auth/login_views.dart';
import 'package:ecuaranch/views/auth/register_views.dart';
import 'package:ecuaranch/views/dashboard/dashboard_views.dart';
import 'package:ecuaranch/views/dashboard/list_animals_views.dart';
import 'package:ecuaranch/views/dashboard/register_animals_pregnancy_views.dart';
import 'package:ecuaranch/views/dashboard/register_animals_views.dart';
import 'package:ecuaranch/views/dashboard/register_animals_weight_views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();  // Inicializa EasyLocalization
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],  // Idiomas soportados
      path: 'assets/translations', // Ruta de los archivos de traducción
      fallbackLocale: const Locale('en', 'US'), // Idioma por defecto
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: context.localizationDelegates,  
      supportedLocales: context.supportedLocales,  
      locale: context.locale, 
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/add-animal': (context) => AddAnimalScreen(),
        '/list-animal': (context) => const AnimalListScreen(),
        '/add-animal-weight': (context) => AddWeightAnimalScreen(),
        '/add-animal-pregancy': (context) => AddPregnancyAnimalScreen()
      },
    );
  }
}
