import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/source/cliente_controller.dart';
import 'package:mysql_flutter_crud/data/models/cliente_model.dart';

final clienteControllerProvider =
    StateNotifierProvider<ClienteController, AsyncValue<List<Cliente>>>(
  (ref) => ClienteController(ref),
);

final clienteListProvider = Provider<List<Cliente>>((ref) {
  return ref.watch(clienteControllerProvider).maybeWhen(
        data: (clientes) => clientes,
        orElse: () => [],
      );
});

final clienteLoadingProvider = Provider<bool>((ref) {
  return ref.watch(clienteControllerProvider).isLoading;
});

final clienteErrorProvider = Provider<String?>((ref) {
  return ref.watch(clienteControllerProvider).error?.toString();
});
