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
    ref.read(prestadorControllerProvider.notifier).loadPrestadores();
  }

  @override
  Widget build(BuildContext context) {
    final prestadores = ref.watch(prestadoresProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prestadores de Servicios'),
        actions: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
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
                    },
                  );
                },
              );
            },
            child: const Text('Agregar Prestador'),
          ),
        ],
      ),
      body: prestadores.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (prestadorList) {
          return ListView.builder(
            itemCount: prestadorList.length,
            itemBuilder: (context, index) {
              final prestador = prestadorList[index];
              return PrestadorTile(prestador: prestador);
            },
          );
        },
      ),
    );
  }
}