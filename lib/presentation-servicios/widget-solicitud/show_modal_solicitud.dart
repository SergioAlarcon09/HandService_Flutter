import 'package:flutter/material.dart';
import 'package:mysql_flutter_crud/data/models/solicitud_servicio_model.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-prestador/action_button_prestador.dart';
import 'package:mysql_flutter_crud/presentation-servicios/widget-solicitud/custom_text_field_solicitud.dart';

class ShowModalSolicitud extends StatefulWidget {
  final void Function(
    int servicioId,
    int tiempoEstimado,
    DateTime fechaInicio,
    DateTime? fechaFin,
    int cantidad,
    double valor,
    int clienteId,
    int? prestadorServicioId,
    String estado,
  ) onAdd;
  final bool isEditMode;
  final Solicitud? editedSolicitud;

  const ShowModalSolicitud({
    super.key,
    required this.onAdd,
    this.isEditMode = false,
    this.editedSolicitud,
  });

  @override
  State<ShowModalSolicitud> createState() => _ShowModalSolicitudState();
}

class _ShowModalSolicitudState extends State<ShowModalSolicitud> {
  final _formKey = GlobalKey<FormState>();
  final _servicioIdController = TextEditingController();
  final _tiempoEstimadoController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaFinController = TextEditingController();
  final _cantidadController = TextEditingController(text: '1');
  final _valorController = TextEditingController();
  final _clienteIdController = TextEditingController();
  final _prestadorIdController = TextEditingController();
  final _estadoController = TextEditingController(text: 'PENDIENTE');

  DateTime? _selectedFechaInicio;
  DateTime? _selectedFechaFin;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.editedSolicitud != null) {
      _servicioIdController.text = widget.editedSolicitud!.servicioId.toString();
      _tiempoEstimadoController.text = widget.editedSolicitud!.tiempoEstimado.toString();
      _fechaInicioController.text = widget.editedSolicitud!.fechaInicio.toString();
      _fechaFinController.text = widget.editedSolicitud!.fechaFin?.toString() ?? '';
      _cantidadController.text = widget.editedSolicitud!.cantidad.toString();
      _valorController.text = widget.editedSolicitud!.valor.toString();
      _clienteIdController.text = widget.editedSolicitud!.clienteId.toString();
      _prestadorIdController.text = widget.editedSolicitud!.prestadorServicioId?.toString() ?? '';
      _estadoController.text = widget.editedSolicitud!.estado;
      _selectedFechaInicio = widget.editedSolicitud!.fechaInicio;
      _selectedFechaFin = widget.editedSolicitud!.fechaFin;
    }
  }

  @override
  void dispose() {
    _servicioIdController.dispose();
    _tiempoEstimadoController.dispose();
    _fechaInicioController.dispose();
    _fechaFinController.dispose();
    _cantidadController.dispose();
    _valorController.dispose();
    _clienteIdController.dispose();
    _prestadorIdController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFechaInicio) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFechaInicio) {
          _selectedFechaInicio = picked;
          _fechaInicioController.text = picked.toString();
        } else {
          _selectedFechaFin = picked;
          _fechaFinController.text = picked.toString();
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onAdd(
        int.parse(_servicioIdController.text),
        int.parse(_tiempoEstimadoController.text),
        _selectedFechaInicio!,
        _selectedFechaFin,
        int.parse(_cantidadController.text),
        double.parse(_valorController.text),
        int.parse(_clienteIdController.text),
        _prestadorIdController.text.isNotEmpty ? int.parse(_prestadorIdController.text) : null,
        _estadoController.text,
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
              widget.isEditMode ? 'Editar Solicitud' : 'Nueva Solicitud',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'ID Servicio*',
              controller: _servicioIdController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Campo obligatorio';
                if (int.tryParse(value!) == null) return 'Debe ser número';
                return null;
              },
            ),
            CustomTextField(
              label: 'Tiempo Estimado (min)*',
              controller: _tiempoEstimadoController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Campo obligatorio';
                if (int.tryParse(value!) == null) return 'Debe ser número';
                return null;
              },
            ),
            GestureDetector(
              onTap: () => _selectDate(context, true),
              child: AbsorbPointer(
                child: CustomTextField(
                  label: 'Fecha Inicio*',
                  controller: _fechaInicioController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Seleccione fecha';
                    return null;
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectDate(context, false),
              child: AbsorbPointer(
                child: CustomTextField(
                  label: 'Fecha Fin (Opcional)',
                  controller: _fechaFinController,
                ),
              ),
            ),
            CustomTextField(
              label: 'Cantidad*',
              controller: _cantidadController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Campo obligatorio';
                if (int.tryParse(value!) == null) return 'Debe ser número';
                return null;
              },
            ),
            CustomTextField(
              label: 'Valor*',
              controller: _valorController,
              keyboardType: TextInputType.number,
              prefixText: '\$ ',
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Campo obligatorio';
                if (double.tryParse(value!) == null) return 'Valor inválido';
                return null;
              },
            ),
            CustomTextField(
              label: 'ID Cliente*',
              controller: _clienteIdController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Campo obligatorio';
                if (int.tryParse(value!) == null) return 'Debe ser número';
                return null;
              },
            ),
            CustomTextField(
              label: 'ID Prestador (Opcional)',
              controller: _prestadorIdController,
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: _estadoController.text,
              items: const [
                DropdownMenuItem(value: 'PENDIENTE', child: Text('Pendiente')),
                DropdownMenuItem(value: 'ACEPTADO', child: Text('Aceptado')),
                DropdownMenuItem(value: 'EN_PROCESO', child: Text('En proceso')),
                DropdownMenuItem(value: 'COMPLETADO', child: Text('Completado')),
                DropdownMenuItem(value: 'CANCELADO', child: Text('Cancelado')),
              ],
              onChanged: (value) {
                setState(() {
                  _estadoController.text = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Estado*',
                border: OutlineInputBorder(),
              ),
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