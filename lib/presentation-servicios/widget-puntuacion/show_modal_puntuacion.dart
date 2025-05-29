import 'package:flutter/material.dart';
import 'package:mysql_flutter_crud/data/models/puntuacion_model.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-prestador/action_button_prestador.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-puntuacion/custom_text_field_puntuacion.dart';

class ShowModalPuntuacion extends StatefulWidget {
  final void Function(int puntuacion, int solicitudId, String? descripcion, String? evidencia) onAdd;
  final bool isEditMode;
  final Puntuacion? editedPuntuacion;

  const ShowModalPuntuacion({
    super.key,
    required this.onAdd,
    this.isEditMode = false,
    this.editedPuntuacion,
  });

  @override
  State<ShowModalPuntuacion> createState() => _ShowModalPuntuacionState();
}

class _ShowModalPuntuacionState extends State<ShowModalPuntuacion> {
  final _formKey = GlobalKey<FormState>();
  final _puntuacionController = TextEditingController();
  final _solicitudIdController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _evidenciaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.editedPuntuacion != null) {
      _puntuacionController.text = widget.editedPuntuacion!.puntuacion.toString();
      _solicitudIdController.text = widget.editedPuntuacion!.solicitudServicioId.toString();
      _descripcionController.text = widget.editedPuntuacion!.descripcion ?? '';
      _evidenciaController.text = widget.editedPuntuacion!.evidencia ?? '';
    }
  }

  @override
  void dispose() {
    _puntuacionController.dispose();
    _solicitudIdController.dispose();
    _descripcionController.dispose();
    _evidenciaController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onAdd(
        int.parse(_puntuacionController.text),
        int.parse(_solicitudIdController.text),
        _descripcionController.text.isNotEmpty ? _descripcionController.text : null,
        _evidenciaController.text.isNotEmpty ? _evidenciaController.text : null,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isEditMode ? 'Editar Puntuación' : 'Nueva Puntuación',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Puntuación (1-5)*',
              controller: _puntuacionController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Ingrese una puntuación';
                final puntuacion = int.tryParse(value!);
                if (puntuacion == null || puntuacion < 1 || puntuacion > 5) {
                  return 'Debe ser entre 1 y 5';
                }
                return null;
              },
            ),
            CustomTextField(
              label: 'ID Solicitud*',
              controller: _solicitudIdController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Ingrese un ID válido';
                if (int.tryParse(value!) == null) return 'Debe ser un número';
                return null;
              },
            ),
            CustomTextField(
              label: 'Descripción',
              controller: _descripcionController,
              maxLines: 3,
            ),
            CustomTextField(
              label: 'Evidencia (URL)',
              controller: _evidenciaController,
            ),
            const SizedBox(height: 20),
            ActionButtons(
              onAdd: _submitForm,
              isEditMode: widget.isEditMode,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}