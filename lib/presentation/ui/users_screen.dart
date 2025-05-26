import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/models/cliente_model.dart';
import 'package:mysql_flutter_crud/data/source/cliente_controller.dart';

import 'package:shared_preferences/shared_preferences.dart';

final clienteControllerProvider =
    StateNotifierProvider<ClienteController, AsyncValue<List<Cliente>>>(
  (ref) => ClienteController(ref),
);

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();

  String? _editingId;
  bool _isLoading = false;
  bool _sessionExpired = false;

  @override
  void initState() {
    super.initState();
    _checkTokenAndLoad();
  }

  Future<void> _checkTokenAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      setState(() => _sessionExpired = true);
    } else {
      ref.read(clienteControllerProvider.notifier).loadClientes();
    }
  }

  void _clearForm() {
    _nombreController.clear();
    _emailController.clear();
    _telefonoController.clear();
    _direccionController.clear();
    _editingId = null;
  }

  void _loadClienteData(Cliente cliente) {
    _nombreController.text = cliente.nombre;
    _emailController.text = cliente.email;
    _telefonoController.text = cliente.telefono;
    _direccionController.text = cliente.direccion;
    _editingId = cliente.id;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final cliente = Cliente(
      nombre: _nombreController.text,
      email: _emailController.text,
      telefono: _telefonoController.text,
      direccion: _direccionController.text,
    );

    try {
      if (_editingId != null) {
        await ref
            .read(clienteControllerProvider.notifier)
            .updateCliente(_editingId!, cliente);
      } else {
        await ref
            .read(clienteControllerProvider.notifier)
            .createCliente(cliente);
      }
      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _editingId != null ? 'Cliente actualizado' : 'Cliente creado'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );

      // Si es error 403, marcamos sesión expirada
      if (e.toString().contains('403')) {
        setState(() => _sessionExpired = true);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content:
            const Text('¿Estás seguro de que quieres eliminar este cliente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(clienteControllerProvider.notifier).deleteCliente(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cliente eliminado'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );

        if (e.toString().contains('403')) {
          setState(() => _sessionExpired = true);
        }
      }
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Sesión expirada'),
            content: const Text(
                'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  _handleLogout();
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      });
    }

    final clientesAsync = ref.watch(clienteControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Clientes - HandService'),
        actions: [
          if (_editingId != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearForm,
              tooltip: 'Cancelar edición',
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulario para agregar/editar clientes
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Ingrese un nombre' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => !value!.contains('@')
                            ? 'Ingrese un email válido'
                            : null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _telefonoController,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Ingrese un teléfono' : null,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _direccionController,
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Ingrese una dirección' : null,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  _editingId != null
                                      ? 'Actualizar Cliente'
                                      : 'Agregar Cliente',
                                  style: const TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Lista de clientes
            Expanded(
              child: clientesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 50),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar clientes',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString().contains('403')
                            ? 'Acceso no autorizado. Verifica tus credenciales.'
                            : error.toString(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(clienteControllerProvider.notifier)
                            .loadClientes(),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
                data: (clientes) {
                  if (clientes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.group_off,
                              size: 50, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No hay clientes registrados',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref
                        .read(clienteControllerProvider.notifier)
                        .loadClientes(),
                    child: ListView.builder(
                      itemCount: clientes.length,
                      itemBuilder: (context, index) {
                        final cliente = clientes[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                              cliente.nombre,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.email, size: 16),
                                    const SizedBox(width: 4),
                                    Text(cliente.email),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 16),
                                    const SizedBox(width: 4),
                                    Text(cliente.telefono),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 16),
                                    const SizedBox(width: 4),
                                    Expanded(child: Text(cliente.direccion)),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _loadClienteData(cliente),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _confirmDelete(cliente.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
