import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/models/prestador_model.dart';
import 'package:mysql_flutter_crud/data/source/prestador_controller.dart';

final prestadorControllerProvider =
    StateNotifierProvider<PrestadorController, AsyncValue<List<Prestador>>>(
  (ref) => PrestadorController(ref),
);

final prestadoresListProvider = Provider<List<Prestador>>((ref) {
  return ref.watch(prestadorControllerProvider).maybeWhen(
        data: (prestadores) => prestadores,
        orElse: () => [],
      );
});

final prestadorLoadingProvider = Provider<bool>((ref) {
  return ref.watch(prestadorControllerProvider).isLoading;
});

final prestadorErrorProvider = Provider<String?>((ref) {
  return ref.watch(prestadorControllerProvider).error?.toString();
});
