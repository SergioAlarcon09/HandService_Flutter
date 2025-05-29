import 'package:flutter/material.dart';

//! MODIFICAR PARA FRONT

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Implementación de la pantalla de inicio
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Screen')),
    );
  }
}
