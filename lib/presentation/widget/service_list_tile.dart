import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/models/service_model.dart';
import 'package:mysql_flutter_crud/presentation/ui/edit_service_screen.dart';
import 'package:mysql_flutter_crud/presentation/widget/delete_service_widget.dart';
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditServiceScreen(
                        service: service,
                        onSave: (nombre, descripcion, valor) async {
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
                      ),
                    ),
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
