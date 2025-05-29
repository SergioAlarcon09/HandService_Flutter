import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/auth_storage.dart';
import 'package:mysql_flutter_crud/core/presentations-auth/auth-ui/login_page.dart';
import 'package:mysql_flutter_crud/core/providers/auth_provider.dart';

//! MODIFICAR PARA FRONT

class SecondScreen extends ConsumerStatefulWidget {
  const SecondScreen({super.key});

  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends ConsumerState<SecondScreen> {
  Future<void> _logout() async {
    //Borrar token del almacenamiento y estado
    await AuthStorage().deleteToken();
    ref.read(authProvider.notifier).state = null;

    //Navegar de vuelta a la pantalla de login
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: const Center(
        child: Text('Bienvenido a la segunda pantalla'),
      ),
    );
  }
}
