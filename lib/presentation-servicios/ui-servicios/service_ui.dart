import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/service_provider.dart';
import 'package:mysql_flutter_crud/data/models/service_model.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-service/show_modal_service.dart';
import '../widget-service/service_list_tile.dart';

class ServiceUi extends ConsumerStatefulWidget {
  const ServiceUi({super.key});

  @override
  ServiceUiState createState() => ServiceUiState();
}

class ServiceUiState extends ConsumerState<ServiceUi> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(serviceControllerProvider.notifier).reloadServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6600),
        title: const Text(
          'Servicios Disponibles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFFF6600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (BuildContext context) {
                    return ShowModalService(
                      onAdd: (nombre, descripcion, valor) async {
                        final newService = Service(
                          nombre: nombre,
                          descripcion: descripcion,
                          valor: valor,
                        );
                        await ref
                            .read(serviceControllerProvider.notifier)
                            .addService(newService);
                      },
                    );
                  },
                );
              },
              child: const Text('Agregar Servicio'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: services.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6600))),
          error: (error, stackTrace) => Center(
              child: Text('Error: $error',
                  style: const TextStyle(color: Colors.red))),
          data: (serviceList) {
            if (serviceList.isEmpty) {
              return const Center(
                child: Text(
                  'No hay servicios disponibles',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }
            return ListView.builder(
              itemCount: serviceList.length,
              itemBuilder: (context, index) {
                final service = serviceList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ServiceTile(service: service),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
