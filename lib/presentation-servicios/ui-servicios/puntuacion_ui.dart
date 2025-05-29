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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(puntuacionControllerProvider.notifier).reloadPuntuaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    final puntuaciones = ref.watch(puntuacionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Puntuaciones'),
        backgroundColor: const Color(0xFFFF6600),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFFF6600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return ShowModalPuntuacion(
                      onAdd: (puntuacion, solicitudId, descripcion,
                          evidencia) async {
                        try {
                          final newPuntuacion = Puntuacion(
                            puntuacion: puntuacion,
                            solicitudServicioId: solicitudId,
                            descripcion: descripcion ?? '',
                            evidencia: evidencia ?? '',
                          );

                          if (solicitudId == null || puntuacion == null) {
                            throw Exception('Faltan campos requeridos');
                          }

                          await ref
                              .read(puntuacionControllerProvider.notifier)
                              .addPuntuacion(newPuntuacion);

                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Puntuación agregada exitosamente')),
                            );
                          }

                          ref
                              .read(puntuacionControllerProvider.notifier)
                              .reloadPuntuaciones();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Error: ${e.toString().replaceAll('Exception: ', '')}')),
                            );
                          }
                        }
                      },
                    );
                  },
                );
              },
              child: const Text(
                'Agregar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(puntuacionControllerProvider.notifier)
              .reloadPuntuaciones();
        },
        child: puntuaciones.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (puntuacionList) {
            if (puntuacionList.isEmpty) {
              return const Center(
                child: Text(
                  'No hay puntuaciones aún',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: puntuacionList.length,
              itemBuilder: (context, index) {
                final puntuacion = puntuacionList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: PuntuacionTile(puntuacion: puntuacion),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
