import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/presentation-servicios/ui-servicios/prestador_servicios_ui.dart';
import 'package:mysql_flutter_crud/presentation-servicios/ui-servicios/puntuacion_ui.dart';
import 'package:mysql_flutter_crud/presentation-servicios/ui-servicios/service_ui.dart';
import 'package:mysql_flutter_crud/presentation-servicios/ui-servicios/solicitud_ui.dart';

class SecondScreen extends ConsumerStatefulWidget {
  const SecondScreen({super.key});

  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends ConsumerState<SecondScreen> {
  final List<MenuOption> menuOptions = [
    MenuOption(
      title: 'Proveedores',
      icon: Icons.people,
      screen: const PrestadorUi(),
    ),
    MenuOption(
      title: 'Servicios',
      icon: Icons.handyman,
      screen: ServiceUi(),
    ),
    MenuOption(
      title: 'Solicitudes',
      icon: Icons.request_page,
      screen: const SolicitudUi(),
    ),
    MenuOption(
      title: 'Puntuaciones',
      icon: Icons.star,
      screen: const PuntuacionUi(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6600),
        title: const Text(
          'HandService',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Sin botón de logout para evitar problemas
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 5,
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Bienvenido!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6600),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Qué deseas hacer hoy?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.2,
                  children: menuOptions.map((option) {
                    return _buildMenuCard(option);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(MenuOption option) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => option.screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(option.icon, size: 40, color: const Color(0xFFFF6600)),
              const SizedBox(height: 12),
              Text(
                option.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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

class MenuOption {
  final String title;
  final IconData icon;
  final Widget screen;

  MenuOption({
    required this.title,
    required this.icon,
    required this.screen,
  });
}
