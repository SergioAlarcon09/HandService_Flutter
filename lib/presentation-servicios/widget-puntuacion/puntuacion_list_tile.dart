import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/puntuacion_provider.dart';
import 'package:mysql_flutter_crud/data/models/puntuacion_model.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-puntuacion/delete_puntuacion_widget.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-puntuacion/show_modal_puntuacion.dart';


class PuntuacionTile extends ConsumerWidget {
  final Puntuacion puntuacion;

  const PuntuacionTile({super.key, required this.puntuacion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          title: Text('Puntuación: ${puntuacion.puntuacion}/5'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Solicitud ID: ${puntuacion.solicitudServicioId}'),
              if (puntuacion.descripcion != null) Text('Descripción: ${puntuacion.descripcion}'),
              if (puntuacion.evidencia != null) Text('Evidencia: ${puntuacion.evidencia}'),
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
                      return ShowModalPuntuacion(
                        onAdd: (puntuacionValor, solicitudId, descripcion, evidencia) async {
                          final updatedPuntuacion = Puntuacion(
                            id: puntuacion.id,
                            puntuacion: puntuacionValor,
                            solicitudServicioId: solicitudId,
                            descripcion: descripcion,
                            evidencia: evidencia,
                          );
                          await ref
                              .read(puntuacionControllerProvider.notifier)
                              .updatePuntuacion(puntuacion.id, updatedPuntuacion);
                        },
                        isEditMode: true,
                        editedPuntuacion: puntuacion,
                      );
                    },
                  );
                },
              ),
              DeletePuntuacionButton(puntuacion: puntuacion),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}