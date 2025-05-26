import 'package:flutter/material.dart';
import 'package:mysql_flutter_crud/data/models/service_model.dart';

void initServiceForm({
  required bool isEditMode,
  required Service? editedService,
  required TextEditingController nombreController,
  required TextEditingController descripcionController,
  required TextEditingController valorController,
}) {
  if (isEditMode && editedService != null) {
    nombreController.text = editedService.nombre;
    descripcionController.text = editedService.descripcion;
    valorController.text = editedService.valor.toStringAsFixed(2);
  } else {
    nombreController.clear();
    descripcionController.clear();
    valorController.clear();
  }
}
