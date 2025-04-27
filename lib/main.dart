import 'package:ecuaranch/controllers/auth/auth_controller.dart';
import 'package:ecuaranch/controllers/dashboard/animals_controller.dart';
import 'package:ecuaranch/controllers/dashboard/create_animals_controller.dart';
import 'package:ecuaranch/controllers/dashboard/stables_controller.dart';
import 'package:ecuaranch/views/dashboard/animals_views.dart';
import 'package:ecuaranch/views/dashboard/create_animals_views.dart';
import 'package:ecuaranch/views/dashboard/stables_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'views/auth/login_views.dart';  // Asegúrate de importar la vista de login
import 'views/auth/register_views.dart';  // Asegúrate de importar la vista de registro
import 'views/dashboard/dashboard_views.dart';  // Asegúrate de importar la vista de dashboard
import 'package:geolocator/geolocator.dart';  // Importa geolocator

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();  // Inicializa EasyLocalization

  // Solicitamos el permiso de ubicación antes de iniciar la aplicación
  await _requestLocationPermission();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')], 
      path: 'assets/translations', 
      fallbackLocale: const Locale('en', 'US'), 
      child: MultiProvider( 
        providers: [
          ChangeNotifierProvider(create: (_) => UserController()),  
          ChangeNotifierProvider(create: (_) => StablesController()),  
          ChangeNotifierProvider(create: (_) => AnimalsController()),
          ChangeNotifierProvider(create: (_) => CreateAnimalsController())
        ],
        child: MyApp(),
      ),
    ),
  );
}

// Función para solicitar permiso de ubicación
Future<void> _requestLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Verifica si el servicio de ubicación está habilitado
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    debugPrint("Location services are disabled.");
    return;  // Si los servicios de ubicación están deshabilitados, no continúa
  }

  // Verifica el estado del permiso de ubicación
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();  // Solicita el permiso
    if (permission == LocationPermission.denied) {
      debugPrint("Location permission denied");
      // Aquí puedes mostrar un diálogo o algo para pedir al usuario que habilite el permiso
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    debugPrint("Location permission denied forever");
    // Si el permiso fue denegado permanentemente, puedes pedirle al usuario que lo habilite manualmente en la configuración
    return;
  }

  debugPrint("Location permission granted");
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
      initialRoute: '/',  // Inicia en la pantalla de bienvenida (que ahora será Login)
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/list-stables': (context)=> const StablesView(),
        '/list-animals': (context) => const AnimalsView(),
        '/create-animal': (context) =>  const AnimalRegistrationScreen()
      },
    );
  }
}
