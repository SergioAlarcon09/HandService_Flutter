import 'package:flutter/material.dart';
import 'package:mysql_flutter_crud/data/models/solicitud_servicio_model.dart';

void initSolicitudForm({
  required bool isEditMode,
  required Solicitud? editedSolicitud,
  required TextEditingController servicioIdController,
  required TextEditingController tiempoEstimadoController,
  required TextEditingController fechaInicioController,
  required TextEditingController fechaFinController,
  required TextEditingController cantidadController,
  required TextEditingController valorController,
  required TextEditingController clienteIdController,
  required TextEditingController prestadorIdController,
  required TextEditingController estadoController,
}) {
  if (isEditMode && editedSolicitud != null) {
    servicioIdController.text = editedSolicitud.servicioId.toString();
    tiempoEstimadoController.text = editedSolicitud.tiempoEstimado.toString();
    fechaInicioController.text = editedSolicitud.fechaInicio.toString();
    fechaFinController.text = editedSolicitud.fechaFin?.toString() ?? '';
    cantidadController.text = editedSolicitud.cantidad.toString();
    valorController.text = editedSolicitud.valor.toString();
    clienteIdController.text = editedSolicitud.clienteId.toString();
    prestadorIdController.text = editedSolicitud.prestadorServicioId?.toString() ?? '';
    estadoController.text = editedSolicitud.estado;
  } else {
    servicioIdController.clear();
    tiempoEstimadoController.clear();
    fechaInicioController.clear();
    fechaFinController.clear();
    cantidadController.clear();
    valorController.clear();
    clienteIdController.clear();
    prestadorIdController.clear();
    estadoController.clear();
  }
}