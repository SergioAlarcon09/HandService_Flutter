import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/presentation/ui/service_ui.dart';
import 'package:mysql_flutter_crud/presentation/ui/login_screen.dart';
import 'package:mysql_flutter_crud/presentation/ui/home_screen.dart'; // Nueva importación
import 'package:mysql_flutter_crud/presentation/ui/providers_screen.dart'; // Nueva importación
import 'package:mysql_flutter_crud/presentation/ui/users_screen.dart'; // Nueva importación

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HandService',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      initialRoute: '/login', // Ruta inicial (login)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(), // Dashboard con las 3 cartas
        '/services': (context) =>
            const ServiceUi(), // Pantalla existente de servicios
        '/providers': (context) =>
            const ProvidersScreen(), // Pantalla nueva (vacía por ahora)
        '/users': (context) =>
            const UsersScreen(), // Pantalla nueva (vacía por ahora)
      },
      // Opcional: Si prefieres manejar rutas no definidas (ej: error 404)
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
      },
    );
  }
}
