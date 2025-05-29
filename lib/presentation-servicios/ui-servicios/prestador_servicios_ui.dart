import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/prestadores_provider.dart';
import 'package:mysql_flutter_crud/data/models/prestador_servicios_model.dart';
import '../widget-prestador/show_modal_prestador.dart';
import '../widget-prestador/prestador_list_tile.dart';

class PrestadorUi extends ConsumerStatefulWidget {
  const PrestadorUi({super.key});

  @override
  PrestadorUiState createState() => PrestadorUiState();
}

class PrestadorUiState extends ConsumerState<PrestadorUi> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(prestadorControllerProvider.notifier).loadPrestadores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prestadores = ref.watch(prestadoresProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6600),
        title: const Text(
          'Prestadores de Servicios',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFFF6600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return ShowModalPrestador(
                      onAdd: (profesion, nivelEducativoId, usuarioId) async {
                        final newPrestador = Prestador(
                          profesion: profesion,
                          nivelEducativoId: nivelEducativoId,
                          usuarioId: usuarioId,
                        );
                        await ref
                            .read(prestadorControllerProvider.notifier)
                            .addPrestador(newPrestador);
                        ref
                            .read(prestadorControllerProvider.notifier)
                            .loadPrestadores();
                      },
                    );
                  },
                );
              },
              child: const Text('Agregar Prestador'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: prestadores.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF6600)),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          data: (prestadorList) {
            if (prestadorList.isEmpty) {
              return const Center(
                child: Text(
                  'No hay prestadores disponibles',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }
            return ListView.builder(
              itemCount: prestadorList.length,
              itemBuilder: (context, index) {
                final prestador = prestadorList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                  child: PrestadorTile(prestador: prestador),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
