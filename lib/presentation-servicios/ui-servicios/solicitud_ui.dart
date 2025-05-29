import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/solicitud_provider.dart';
import 'package:mysql_flutter_crud/data/models/solicitud_servicio_model.dart';
import '../widget-solicitud/show_modal_solicitud.dart';
import '../widget-solicitud/solicitud_list_tile.dart';

class SolicitudUi extends ConsumerStatefulWidget {
  const SolicitudUi({super.key});

  @override
  SolicitudUiState createState() => SolicitudUiState();
}

class SolicitudUiState extends ConsumerState<SolicitudUi> {
  @override
  void initState() {
    super.initState();
    ref.read(solicitudControllerProvider.notifier).reloadSolicitudes();
  }

  @override
  Widget build(BuildContext context) {
    final solicitudes = ref.watch(solicitudProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes de Servicio'),
        actions: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return ShowModalSolicitud(
                    onAdd: (
                      servicioId,
                      tiempoEstimado,
                      fechaInicio,
                      fechaFin,
                      cantidad,
                      valor,
                      clienteId,
                      prestadorServicioId,
                      estado,
                    ) async {
                      final newSolicitud = Solicitud(
                        servicioId: servicioId,
                        tiempoEstimado: tiempoEstimado,
                        fechaInicio: fechaInicio,
                        fechaFin: fechaFin,
                        cantidad: cantidad,
                        valor: valor,
                        clienteId: clienteId,
                        prestadorServicioId: prestadorServicioId,
                        estado: estado,
                      );
                      await ref
                          .read(solicitudControllerProvider.notifier)
                          .addSolicitud(newSolicitud);
                    },
                  );
                },
              );
            },
            child: const Text('Nueva Solicitud'),
          ),
        ],
      ),
      body: solicitudes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (solicitudList) {
          return ListView.builder(
            itemCount: solicitudList.length,
            itemBuilder: (context, index) {
              final solicitud = solicitudList[index];
              return SolicitudTile(solicitud: solicitud);
            },
          );
        },
      ),
    );
  }
}