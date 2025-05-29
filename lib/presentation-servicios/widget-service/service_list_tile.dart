import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/models/service_model.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-service/show_modal_service.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-service/delete_service_widget.dart';
import 'package:mysql_flutter_crud/core/providers/service_provider.dart';

class ServiceTile extends ConsumerWidget {
  final Service service;

  const ServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          title: Text(service.nombre),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(service.descripcion),
              Text('Valor: \$${service.valor.toStringAsFixed(2)}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return ShowModalService(
                        onAdd: (nombre, descripcion, valor) async {
                          final updatedService = Service(
                            id: service.id,
                            nombre: nombre,
                            descripcion: descripcion,
                            valor: valor,
                          );
                          await ref
                              .read(serviceControllerProvider.notifier)
                              .updateService(service.id, updatedService);
                        },
                        isEditMode: true,
                        editedService: service,
                      );
                    },
                  );
                },
              ),
              DeleteServiceButton(service: service),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}