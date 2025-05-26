import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/solicitud_providers.dart';
import '../../data/models/solicitud_model.dart';

class CreateSolicitudScreen extends ConsumerStatefulWidget {
  final VoidCallback? onCreated;

  const CreateSolicitudScreen({Key? key, this.onCreated}) : super(key: key);

  @override
  ConsumerState<CreateSolicitudScreen> createState() =>
      _CreateSolicitudScreenState();
}

class _CreateSolicitudScreenState extends ConsumerState<CreateSolicitudScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _servicioId;
  String? _clienteId;
  String? _prestadorId;
  DateTime? _fechaSolicitud;
  String? _detalles;

  bool _isSubmitting = false;

  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _detallesController = TextEditingController();

  @override
  void dispose() {
    _fechaController.dispose();
    _detallesController.dispose();
    super.dispose();
  }

  Future<void> _pickFechaSolicitud() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaSolicitud ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _fechaSolicitud = pickedDate;
        _fechaController.text =
            _fechaSolicitud!.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_fechaSolicitud == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor selecciona la fecha de la solicitud')),
      );
      return;
    }

    _formKey.currentState!.save();

    final nuevaSolicitud = SolicitudServicio(
      servicioId: _servicioId!,
      clienteId: _clienteId!,
      prestadorId: _prestadorId!,
      fechaSolicitud: _fechaSolicitud!,
      detalles: _detalles,
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(solicitudControllerProvider.notifier)
          .createSolicitud(nuevaSolicitud);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud creada correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      widget.onCreated?.call();

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear solicitud: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Cita'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSubmitting
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'ID del Servicio',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el ID del servicio';
                        }
                        return null;
                      },
                      onSaved: (value) => _servicioId = value,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'ID del Cliente',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el ID del cliente';
                        }
                        return null;
                      },
                      onSaved: (value) => _clienteId = value,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'ID del Prestador de Servicio',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el ID del prestador';
                        }
                        return null;
                      },
                      onSaved: (value) => _prestadorId = value,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _fechaController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de la Solicitud',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: _pickFechaSolicitud,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecciona la fecha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _detallesController,
                      decoration: const InputDecoration(
                        labelText: 'Detalles (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onSaved: (value) => _detalles = value,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Agendar Cita',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
