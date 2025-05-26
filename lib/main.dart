import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:mysql_flutter_crud/presentation/ui/service_ui.dart';
import 'package:mysql_flutter_crud/presentation/ui/login_screen.dart';
import 'package:mysql_flutter_crud/presentation/ui/home_screen.dart';
import 'package:mysql_flutter_crud/presentation/ui/providers_screen.dart';
import 'package:mysql_flutter_crud/presentation/ui/users_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Simple SplashScreen widget definition
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// Provider para manejar el token almacenado
final authTokenProvider = StateProvider<String?>((ref) => null);

// Flutter Secure Storage
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late Future<String?> _initTokenFuture;

  @override
  void initState() {
    super.initState();
    _initTokenFuture = _loadToken();
  }

  Future<String?> _loadToken() async {
    try {
      return await secureStorage.read(key: 'authToken');
    } catch (e) {
      debugPrint('Error reading auth token: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _initTokenFuture,
      builder: (context, snapshot) {
        // Mostrar splash screen mientras carga
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            home: SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        }

        return Consumer(
          builder: (context, ref, child) {
            // Actualizamos el provider solo cuando tenemos el token
            if (snapshot.hasData) {
              ref.read(authTokenProvider.notifier).state = snapshot.data;
            }

            final token = ref.watch(authTokenProvider);
            final initialRoute = (token != null) ? '/home' : '/login';

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
              initialRoute: initialRoute,
              routes: {
                '/login': (context) => const LoginScreen(),
                '/home': (context) => const HomeScreen(),
                '/services': (context) => const ServiceUi(),
                '/providers': (context) => const ProvidersScreen(),
                '/users': (context) => const UsersScreen(),
              },
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => const Scaffold(
                    body: Center(child: Text('Ruta no encontrada')),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
