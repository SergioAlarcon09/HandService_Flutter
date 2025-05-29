import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/solicitud_provider.dart';
import 'package:mysql_flutter_crud/data/models/solicitud_servicio_model.dart';

class DeleteSolicitudButton extends ConsumerWidget {
  final Solicitud solicitud;
  
  const DeleteSolicitudButton({
    super.key, 
    required this.solicitud
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      tooltip: 'Eliminar solicitud',
      onPressed: () => _showDeleteDialog(context, ref),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar solicitud #${solicitud.id}?'),
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
      await _deleteSolicitud(context, ref);
    }
  }

  Future<void> _deleteSolicitud(BuildContext context, WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final controller = ref.read(solicitudControllerProvider.notifier);
    
    try {
      await controller.deleteSolicitud(solicitud.id);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Solicitud #${solicitud.id} eliminada'),
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