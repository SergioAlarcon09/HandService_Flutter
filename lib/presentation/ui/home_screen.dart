import 'package:flutter/material.dart';
import 'package:mysql_flutter_crud/presentation/ui/service_ui.dart';
import 'package:mysql_flutter_crud/presentation/ui/appointment_ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HandService',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40.0, bottom: 20.0), // Aumenté el top padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Primera fila de tarjetas
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0), // Espacio entre filas
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCard(
                            context, 'PROVEEDORES', Icons.people, '/providers'),
                        const SizedBox(width: 20), // Espacio entre tarjetas
                        _buildCard(context, 'USUARIOS', Icons.person, '/users'),
                      ],
                    ),
                  ),
                  // Segunda fila de tarjetas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCard(context, 'SERVICIOS', Icons.handyman, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ServiceUi()),
                        );
                      }),
                      const SizedBox(width: 20), // Espacio entre tarjetas
                      _buildCard(context, 'AGENDAMIENTO', Icons.calendar_today,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AppointmentUi()),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, IconData icon, dynamic action) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          if (action is String) {
            Navigator.pushNamed(context, action);
          } else if (action is Function) {
            action();
          }
        },
        child: Container(
          width: 160,
          height: 160,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
