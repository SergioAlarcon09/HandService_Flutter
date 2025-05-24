import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/service_provider.dart';
import 'package:mysql_flutter_crud/data/models/service_model.dart';
import 'package:mysql_flutter_crud/presentation/widget/show_modal_service.dart';
import '../widget/service_list_tile.dart';

class ServiceUi extends ConsumerStatefulWidget {
  const ServiceUi({super.key});

  @override
  ServiceUiState createState() => ServiceUiState();
}

class ServiceUiState extends ConsumerState<ServiceUi> {
  @override
  void initState() {
    super.initState();
    ref.read(serviceControllerProvider.notifier).reloadServices();
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios Disponibles'),
        actions: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
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
        ],
      ),
      body: services.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (serviceList) {
          return ListView.builder(
            itemCount: serviceList.length,
            itemBuilder: (context, index) {
              final service = serviceList[index];
              return ServiceTile(service: service);
            },
          );
        },
      ),
    );
  }
}
