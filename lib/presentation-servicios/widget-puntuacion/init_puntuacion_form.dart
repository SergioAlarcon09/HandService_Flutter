import 'package:flutter/material.dart';
import 'package:mysql_flutter_crud/data/models/puntuacion_model.dart';

void initPuntuacionForm({
  required bool isEditMode,
  required Puntuacion? editedPuntuacion,
  required TextEditingController puntuacionController,
  required TextEditingController solicitudIdController,
  required TextEditingController descripcionController,
  required TextEditingController evidenciaController,
}) {
  if (isEditMode && editedPuntuacion != null) {
    puntuacionController.text = editedPuntuacion.puntuacion.toString();
    solicitudIdController.text = editedPuntuacion.solicitudServicioId.toString();
    descripcionController.text = editedPuntuacion.descripcion ?? '';
    evidenciaController.text = editedPuntuacion.evidencia ?? '';
  } else {
    puntuacionController.clear();
    solicitudIdController.clear();
    descripcionController.clear();
    evidenciaController.clear();
  }
}