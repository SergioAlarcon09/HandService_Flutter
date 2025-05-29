import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/puntuacion_provider.dart';
import 'package:mysql_flutter_crud/data/models/puntuacion_model.dart';

class DeletePuntuacionButton extends ConsumerWidget {
  final Puntuacion puntuacion;
  
  const DeletePuntuacionButton({
    super.key, 
    required this.puntuacion
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      tooltip: 'Eliminar puntuación',
      onPressed: () => _showDeleteDialog(context, ref),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar esta puntuación?'),
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
      await _deletePuntuacion(context, ref);
    }
  }

  Future<void> _deletePuntuacion(BuildContext context, WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final controller = ref.read(puntuacionControllerProvider.notifier);
    
    try {
      await controller.deletePuntuacion(puntuacion.id);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Puntuación eliminada'),
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