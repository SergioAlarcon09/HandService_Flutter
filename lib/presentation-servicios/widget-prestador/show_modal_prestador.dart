import 'package:flutter/material.dart';
import 'package:mysql_flutter_crud/data/models/prestador_servicios_model.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-prestador/action_button_prestador.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-prestador/custom_text_field_prestador.dart';

class ShowModalPrestador extends StatefulWidget {
  final void Function(String profesion, int nivelEducativoId, int usuarioId) onAdd;
  final bool isEditMode;
  final Prestador? editedPrestador;

  const ShowModalPrestador({
    super.key,
    required this.onAdd,
    this.isEditMode = false,
    this.editedPrestador,
  });

  @override
  State<ShowModalPrestador> createState() => _ShowModalPrestadorState();
}

class _ShowModalPrestadorState extends State<ShowModalPrestador> {
  final _formKey = GlobalKey<FormState>();
  final _profesionController = TextEditingController();
  final _nivelEducativoController = TextEditingController();
  final _usuarioIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.editedPrestador != null) {
      _profesionController.text = widget.editedPrestador!.profesion;
      _nivelEducativoController.text = widget.editedPrestador!.nivelEducativoId.toString();
      _usuarioIdController.text = widget.editedPrestador!.usuarioId.toString();
    }
  }

  @override
  void dispose() {
    _profesionController.dispose();
    _nivelEducativoController.dispose();
    _usuarioIdController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onAdd(
        _profesionController.text.trim(),
        int.parse(_nivelEducativoController.text),
        int.parse(_usuarioIdController.text),
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
              widget.isEditMode ? 'Editar Prestador' : 'Nuevo Prestador',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Profesión*',
              controller: _profesionController,
              validator: (value) => value?.isEmpty ?? true 
                  ? 'Este campo es obligatorio' 
                  : null,
            ),
            CustomTextField(
              label: 'Nivel Educativo ID*',
              controller: _nivelEducativoController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Ingrese un ID válido';
                if (int.tryParse(value!) == null) return 'Debe ser un número';
                return null;
              },
            ),
            CustomTextField(
              label: 'Usuario ID*',
              controller: _usuarioIdController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Ingrese un ID válido';
                if (int.tryParse(value!) == null) return 'Debe ser un número';
                return null;
              },
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