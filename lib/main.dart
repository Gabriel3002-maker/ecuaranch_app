import 'package:ecuaranch/controllers/auth/auth_controller.dart';
import 'package:ecuaranch/controllers/dashboard/animals_controller.dart';
import 'package:ecuaranch/controllers/dashboard/create_animals_controller.dart';
import 'package:ecuaranch/controllers/dashboard/health_alert_controller.dart';
import 'package:ecuaranch/controllers/dashboard/stables_controller.dart';
import 'package:ecuaranch/controllers/dashboard/weight_alert_controller.dart';
import 'package:ecuaranch/controllers/events/get_events_controller.dart';
import 'package:ecuaranch/controllers/livestock/get_expenses_controller.dart';
import 'package:ecuaranch/controllers/livestock/get_factory_controller.dart';
import 'package:ecuaranch/controllers/livestock/get_leads_controller.dart';
import 'package:ecuaranch/controllers/livestock/get_sales_controller.dart';
import 'package:ecuaranch/controllers/livestock/get_warehouses_controller.dart';
import 'package:ecuaranch/views/dashboard/animals_views.dart';
import 'package:ecuaranch/views/dashboard/create_animals_views.dart';
import 'package:ecuaranch/views/dashboard/health_alert_views.dart';
import 'package:ecuaranch/views/dashboard/main_tab_views.dart';
import 'package:ecuaranch/views/dashboard/stables_views.dart';
import 'package:ecuaranch/views/dashboard/weight_alert_views.dart';
import 'package:ecuaranch/views/livestock/create_person_views.dart';
import 'package:ecuaranch/views/livestock/expenses_views.dart';
import 'package:ecuaranch/views/livestock/factory_views.dart';
import 'package:ecuaranch/views/livestock/leads_views.dart';
import 'package:ecuaranch/views/livestock/register_person_views.dart';
import 'package:ecuaranch/views/livestock/sales_views.dart';
import 'package:ecuaranch/views/livestock/stables_views.dart';
import 'package:ecuaranch/views/livestock/warehouses_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'views/auth/login_views.dart';  // Asegúrate de importar la vista de login
import 'views/auth/register_views.dart';  // Asegúrate de importar la vista de registro
import 'package:geolocator/geolocator.dart';  // Importa geolocator
import 'controllers/notification_controller.dart';  // Agrega la importación del controlador

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();  // Inicializa EasyLocalization

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
          ChangeNotifierProvider(create: (_) => CreateAnimalsController()),
          ChangeNotifierProvider(create: (_) => GetEventsControllerController()),
          ChangeNotifierProvider(create: (_) => GetExpensesController()),
          ChangeNotifierProvider(create: (_) => GetFactoryController()),
          ChangeNotifierProvider(create: (_) => GetLeadsController()),
          ChangeNotifierProvider(create: (_) => GetSalesController()),
          ChangeNotifierProvider(create: (_) => GetWarehousesController()),
          ChangeNotifierProvider(create: (_) => HealthAlertController()),
          ChangeNotifierProvider(create: (_) => WeightAlertController()),
          ChangeNotifierProvider(create: (_) => NotificationController("ws://ecuaranch-backend.duckdns.org/ws/alertas")),
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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const MainTabScreen(),
        '/list-stables': (context)=> const StablesView(),
        '/list-animals': (context) => const AnimalsView(),
        '/create-animal': (context) =>  const AnimalRegistrationScreen(),
        '/alert-heath': (context) => const HealthAlertViews(),
        '/alert-weight': (context) => const WeightAlertViews(),
        '/create-person':(context) => const CreatePersonViews(),
        '/list-expenses': (context) =>  const ExpensesViews(),
        '/list-factory': (context) =>  const FactoryViews(),
        '/list-leads': (context) =>  const LeadsViews(),
        '/list-sales': (context) =>  const SalesViews(),
        '/list-warehouses': (context) =>  const WarehousesViews(),
        '/create-stables': (context) =>  const RegisterStableView(),
        '/create-partner': (context) => const RegisterPersonView()
      },
    );
  }
}
