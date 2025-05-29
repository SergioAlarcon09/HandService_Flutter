import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/prestadores_provider.dart';
import 'package:mysql_flutter_crud/data/models/prestador_servicios_model.dart';

class DeletePrestadorButton extends ConsumerWidget {
  final Prestador prestador;
  
  const DeletePrestadorButton({
    super.key, 
    required this.prestador
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      tooltip: 'Eliminar prestador',
      onPressed: () => _showDeleteDialog(context, ref),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de eliminar al prestador "${prestador.profesion}"?',
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
      await _deletePrestador(context, ref);
    }
  }

  Future<void> _deletePrestador(BuildContext context, WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final controller = ref.read(prestadorControllerProvider.notifier);
    
    try {
      await controller.deletePrestador(prestador.id);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Prestador "${prestador.profesion}" eliminado'),
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