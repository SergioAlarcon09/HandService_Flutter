import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/models/service_model.dart';
import 'package:mysql_flutter_crud/core/providers/service_provider.dart';

class EditServiceScreenWithProvider extends ConsumerStatefulWidget {
  final Service service;

  const EditServiceScreenWithProvider({super.key, required this.service});

  @override
  ConsumerState<EditServiceScreenWithProvider> createState() =>
      _EditServiceScreenWithProviderState();
}

class _EditServiceScreenWithProviderState
    extends ConsumerState<EditServiceScreenWithProvider> {
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController valorController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.service.nombre);
    descripcionController =
        TextEditingController(text: widget.service.descripcion);
    valorController =
        TextEditingController(text: widget.service.valor.toString());
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    valorController.dispose();
    super.dispose();
  }

  void _guardarCambios() async {
    final nombre = nombreController.text;
    final descripcion = descripcionController.text;
    final valor = double.tryParse(valorController.text) ?? 0.0;

    final updatedService = Service(
      id: widget.service.id,
      nombre: nombre,
      descripcion: descripcion,
      valor: valor,
    );

    await ref
        .read(serviceControllerProvider.notifier)
        .updateService(widget.service.id, updatedService);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Servicio')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valorController,
              decoration: const InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _guardarCambios,
              icon: const Icon(Icons.save),
              label: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
