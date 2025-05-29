import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/prestadores_provider.dart';
import 'package:mysql_flutter_crud/data/models/prestador_servicios_model.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-prestador/show_modal_prestador.dart';
import 'delete_prestador_widget.dart';

class PrestadorTile extends ConsumerWidget {
  final Prestador prestador;

  const PrestadorTile({super.key, required this.prestador});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          title: Text(prestador.profesion),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nivel Educativo ID: ${prestador.nivelEducativoId}'),
              Text('Usuario ID: ${prestador.usuarioId}'),
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
                      return ShowModalPrestador(
                        onAdd: (profesion, nivelEducativoId, usuarioId) async {
                          final updatedPrestador = Prestador(
                            id: prestador.id,
                            profesion: profesion,
                            nivelEducativoId: nivelEducativoId,
                            usuarioId: usuarioId,
                          );
                          await ref
                              .read(prestadorControllerProvider.notifier)
                              .updatePrestador(prestador.id, updatedPrestador);
                        },
                        isEditMode: true,
                        editedPrestador: prestador,
                      );
                    },
                  );
                },
              ),
              DeletePrestadorButton(prestador: prestador),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}