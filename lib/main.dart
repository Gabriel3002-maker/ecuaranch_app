import 'package:ecuaranch/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';  // Importa easy_localization
import 'views/auth/login_views.dart';  // Asegúrate de importar la vista de login
import 'views/auth/register_views.dart';  // Asegúrate de importar la vista de registro
import 'views/dashboard/dashboard_views.dart';  // Asegúrate de importar la vista de dashboard

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();  // Inicializa EasyLocalization
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],  // Idiomas soportados
      path: 'assets/translations', // Ruta de los archivos de traducción
      fallbackLocale: const Locale('en', 'US'), // Idioma por defecto
      child: ChangeNotifierProvider(  // Proveedor de UserController
        create: (_) => UserController(),
        child: MyApp(),
      ),
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
        '/dashboard': (context) => const DashboardScreen()
      },
    );
  }
}
