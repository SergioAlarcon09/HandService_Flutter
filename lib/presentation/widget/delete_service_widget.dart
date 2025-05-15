import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/service_provider.dart';
import 'package:mysql_flutter_crud/data/models/service_model.dart';

class DeleteServiceButton extends ConsumerWidget {
  final Service service;
  
  const DeleteServiceButton({
    super.key, 
    required this.service
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      tooltip: 'Eliminar servicio',
      onPressed: () => _showDeleteDialog(context, ref),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de eliminar el servicio "${service.nombre}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteService(context, ref);
    }
  }

  Future<void> _deleteService(BuildContext context, WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final controller = ref.read(serviceControllerProvider.notifier);
    
    try {
      await controller.deleteService(service.id);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Servicio "${service.nombre}" eliminado'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}