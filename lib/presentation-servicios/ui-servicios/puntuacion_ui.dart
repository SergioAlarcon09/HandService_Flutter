import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/puntuacion_provider.dart';
import 'package:mysql_flutter_crud/data/models/puntuacion_model.dart';
import '../widget-puntuacion/show_modal_puntuacion.dart';
import '../widget-puntuacion/puntuacion_list_tile.dart';

class PuntuacionUi extends ConsumerStatefulWidget {
  const PuntuacionUi({super.key});

  @override
  PuntuacionUiState createState() => PuntuacionUiState();
}

class PuntuacionUiState extends ConsumerState<PuntuacionUi> {
  @override
  void initState() {
    super.initState();
    ref.read(puntuacionControllerProvider.notifier).reloadPuntuaciones();
  }

  @override
  Widget build(BuildContext context) {
    final puntuaciones = ref.watch(puntuacionProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puntuaciones'),
        actions: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return ShowModalPuntuacion(
                    onAdd: (puntuacion, solicitudId, descripcion, evidencia) async {
                      final newPuntuacion = Puntuacion(
                        puntuacion: puntuacion,
                        solicitudServicioId: solicitudId,
                        descripcion: descripcion,
                        evidencia: evidencia,
                      );
                      await ref
                          .read(puntuacionControllerProvider.notifier)
                          .addPuntuacion(newPuntuacion);
                    },
                  );
                },
              );
            },
            child: const Text('Agregar Puntuación'),
          ),
        ],
      ),
      body: puntuaciones.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (puntuacionList) {
          return ListView.builder(
            itemCount: puntuacionList.length,
            itemBuilder: (context, index) {
              final puntuacion = puntuacionList[index];
              return PuntuacionTile(puntuacion: puntuacion);
            },
          );
        },
      ),
    );
  }
}