import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/solicitud_provider.dart';
import 'package:mysql_flutter_crud/data/models/solicitud_servicio_model.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-solicitud/show_modal_solicitud.dart';
import 'delete_solicitud_widget.dart';

class SolicitudTile extends ConsumerWidget {
  final Solicitud solicitud;

  const SolicitudTile({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          title: Text('Solicitud #${solicitud.id} - ${solicitud.estado}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Servicio ID: ${solicitud.servicioId}'),
              Text('Cliente ID: ${solicitud.clienteId}'),
              Text('Tiempo estimado: ${solicitud.tiempoEstimado} min'),
              Text('Valor: \$${solicitud.valor.toStringAsFixed(2)}'),
              Text('Fecha inicio: ${solicitud.fechaInicio.toString().substring(0, 10)}'),
              if (solicitud.fechaFin != null)
                Text('Fecha fin: ${solicitud.fechaFin.toString().substring(0, 10)}'),
              if (solicitud.prestadorServicioId != null)
                Text('Prestador ID: ${solicitud.prestadorServicioId}'),
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
                          final updatedSolicitud = Solicitud(
                            id: solicitud.id,
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
                              .updateSolicitud(solicitud.id, updatedSolicitud);
                        },
                        isEditMode: true,
                        editedSolicitud: solicitud,
                      );
                    },
                  );
                },
              ),
              DeleteSolicitudButton(solicitud: solicitud),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}