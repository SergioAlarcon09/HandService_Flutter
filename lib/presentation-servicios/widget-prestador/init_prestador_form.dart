import 'package:flutter/material.dart';
import 'package:mysql_flutter_crud/data/models/prestador_servicios_model.dart';

void initPrestadorForm({
  required bool isEditMode,
  required Prestador? editedPrestador,
  required TextEditingController profesionController,
  required TextEditingController nivelEducativoIdController,
  required TextEditingController usuarioIdController,
}) {
  if (isEditMode && editedPrestador != null) {
    profesionController.text = editedPrestador.profesion;
    nivelEducativoIdController.text = editedPrestador.nivelEducativoId.toString();
    usuarioIdController.text = editedPrestador.usuarioId.toString();
  } else {
    profesionController.clear();
    nivelEducativoIdController.clear();
    usuarioIdController.clear();
  }
}