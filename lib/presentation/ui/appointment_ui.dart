import 'package:flutter/material.dart';

class AppointmentUi extends StatelessWidget {
  const AppointmentUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamiento de Citas'),
      ),
      body: const Center(
        child: Text('Pantalla de Agendamiento de Citas'),
      ),
    );
  }
}
