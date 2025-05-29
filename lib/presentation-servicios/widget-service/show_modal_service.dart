import 'package:flutter/material.dart';
import 'package:mysql_flutter_crud/data/models/service_model.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-service/action_button_service.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-service/custom_text_field_service.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-service/init_service_form.dart';

class ShowModalService extends StatefulWidget {
  final void Function(String nombre, String descripcion, double valor) onAdd;
  final bool isEditMode;
  final Service? editedService;

  const ShowModalService({
    super.key,
    required this.onAdd,
    this.isEditMode = false,
    this.editedService,
  });

  @override
  State<ShowModalService> createState() => _ShowModalServiceState();
}

class _ShowModalServiceState extends State<ShowModalService> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initServiceForm(
      isEditMode: widget.isEditMode,
      editedService: widget.editedService,
      nombreController: _nombreController,
      descripcionController: _descripcionController,
      valorController: _valorController,
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onAdd(
        _nombreController.text.trim(),
        _descripcionController.text.trim(),
        double.parse(_valorController.text),
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
              widget.isEditMode ? 'Editar Servicio' : 'Nuevo Servicio',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Nombre del Servicio*',
              controller: _nombreController,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Este campo es obligatorio' : null,
            ),
            CustomTextField(
              label: 'Descripción',
              controller: _descripcionController,
              maxLines: 3,
            ),
            CustomTextField(
              label: 'Valor*',
              controller: _valorController,
              keyboardType: TextInputType.number,
              prefixText: '\$ ',
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Ingrese un valor';
                if (double.tryParse(value!) == null) return 'Valor inválido';
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
