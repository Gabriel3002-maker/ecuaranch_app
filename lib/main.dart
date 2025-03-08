import 'package:ecuaranch/views/auth/login_views.dart';
import 'package:ecuaranch/views/auth/register_views.dart';
import 'package:ecuaranch/views/dashboard/dashboard_views.dart';
import 'package:ecuaranch/views/dashboard/list_animals_views.dart';
import 'package:ecuaranch/views/dashboard/register_animals_pregnancy_views.dart';
import 'package:ecuaranch/views/dashboard/register_animals_views.dart';
import 'package:ecuaranch/views/dashboard/register_animals_weight_views.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/add-animal': (context) => AddAnimalScreen(),
        '/list-animal': (context) => const AnimalListScreen(),
        '/add-animal-weight': (context) =>  AddWeightAnimalScreen(),
        '/add-animal-pregancy': (context) => AddPregnancyAnimalScreen()
      },
    );
  }
}

