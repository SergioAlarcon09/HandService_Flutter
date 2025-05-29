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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(solicitudControllerProvider.notifier).reloadSolicitudes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final solicitudes = ref.watch(solicitudProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6600),
        title: const Text(
          'Solicitudes de Servicio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.white,
            tooltip: 'Nueva Solicitud',
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
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
                      final valorDouble = valor is String
                          ? double.tryParse(valor as String) ?? 0.0
                          : valor is num
                              ? valor.toDouble()
                              : 0.0;

                      final newSolicitud = Solicitud(
                        servicioId: servicioId,
                        tiempoEstimado: tiempoEstimado,
                        fechaInicio: fechaInicio,
                        fechaFin: fechaFin,
                        cantidad: cantidad,
                        valor: valorDouble,
                        clienteId: clienteId,
                        prestadorServicioId: prestadorServicioId,
                        estado: estado,
                      );
                      await ref
                          .read(solicitudControllerProvider.notifier)
                          .addSolicitud(newSolicitud);
                      ref
                          .read(solicitudControllerProvider.notifier)
                          .reloadSolicitudes();
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFFFF6600),
        onRefresh: () async {
          await ref
              .read(solicitudControllerProvider.notifier)
              .reloadSolicitudes();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: solicitudes.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6600)),
            ),
            error: (error, stackTrace) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            data: (solicitudList) {
              if (solicitudList.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay solicitudes disponibles',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              }
              return ListView.builder(
                itemCount: solicitudList.length,
                itemBuilder: (context, index) {
                  final solicitud = solicitudList[index];
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
                    child: SolicitudTile(solicitud: solicitud),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
