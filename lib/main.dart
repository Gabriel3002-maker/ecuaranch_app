import 'package:ecuaranch/views/dashboard/animals_views.dart';
import 'package:ecuaranch/views/dashboard/create_animals_views.dart';
import 'package:ecuaranch/views/dashboard/health_alert_views.dart';
import 'package:ecuaranch/views/dashboard/historic/register_animal_partner_views.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
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
import 'package:ecuaranch/views/auth/login_views.dart';
import 'package:ecuaranch/views/auth/register_views.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controllers/notification_controller.dart';

// Global key to access Navigator's context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  PermissionController permissionController = PermissionController(navigatorKey);
  bool isLocationServiceEnabled = await permissionController.checkPermissionStatus();

  if (isLocationServiceEnabled) {
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
  } else {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: MaterialApp(
          home: _LocationPermissionDeniedScreen(),
        ),
      ),
    );
  }
}

class PermissionController {
  final GlobalKey<NavigatorState> navigatorKey;

  PermissionController(this.navigatorKey);

  Future<bool> checkPermissionStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      debugPrint("Location services are disabled.");
      return false;  // Si los servicios de ubicación están deshabilitados, no continúa
    }

    // Verifica el estado del permiso de ubicación
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();  // Solicita el permiso
      if (permission == LocationPermission.denied) {
        debugPrint("Location permission denied");
        _showPermissionDialog();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Location permission denied forever");
      _showPermissionDialog();
      return false;
    }

    debugPrint("Location permission granted");
    return true;  // Si el permiso está concedido, devuelve true
  }

  // Muestra un cuadro de diálogo pidiendo al usuario que habilite el permiso
  void _showPermissionDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text('Please enable location services to continue.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Cierra el cuadro de diálogo
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// Pantalla que aparece cuando los permisos de ubicación no están habilitados
class _LocationPermissionDeniedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Image.asset(
                'assets/icons/Logo@300x.png',
                fit: BoxFit.contain,  // Usa BoxFit.contain para que la imagen se ajuste sin distorsionarse
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Contenido centrado
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    '¡Por favor activa la ubicación!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2))],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Para continuar, por favor activa los servicios de ubicación en tu celular o GPS.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2))],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      await _openLocationSettings(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A5A57),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Ir a Configuración',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  Future<void> _openLocationSettings(BuildContext context) async {
    const locationSettingsUrl = 'android.settings.LOCATION_SOURCE_SETTINGS';
    const iosLocationSettingsUrl = 'App-prefs:root=LOCATION_SERVICES';

    // Verifica si el contexto no es nulo
    if (context == null) {
      debugPrint("Context is null.");
      return;
    }

    // Verifica la plataforma
    if (Theme.of(context).platform == TargetPlatform.android) {
      // Intento para Android con la URL del Intent correctamente formateada
      final Uri androidUri = Uri.parse('intent://$locationSettingsUrl#Intent;scheme=package;package=com.android.settings;end');
      await _launchUrl(androidUri);
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      final Uri iosUri = Uri.parse(iosLocationSettingsUrl);
      await _launchUrl(iosUri);
    }
  }

  Future<void> _launchUrl(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'No se puede abrir la URL $url';
      }
    } catch (e) {
      debugPrint("Error lanzando la URL: $e");
    }
  }


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
        '/create-animal': (context) => const AnimalRegistrationScreen(),
        '/alert-heath': (context) => const HealthAlertViews(),
        '/alert-weight': (context) => const WeightAlertViews(),
        '/create-person':(context) => const CreatePersonViews(),
        '/list-expenses': (context) => const ExpensesViews(),
        '/list-factory': (context) => const FactoryViews(),
        '/list-leads': (context) => const LeadsViews(),
        '/list-sales': (context) => const SalesViews(),
        '/list-warehouses': (context) => const WarehousesViews(),
        '/create-stables': (context) => const RegisterStableView(),
        '/create-partner': (context) => const RegisterPersonView(),
        '/create-partner-animal':(context) => const RegisterAnimalPartnerViews()
      },
    );
  }
}
