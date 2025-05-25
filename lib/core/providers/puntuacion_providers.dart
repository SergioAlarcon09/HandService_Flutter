import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/models/puntuacion_model.dart';
import 'package:mysql_flutter_crud/data/source/puntuacion_controller.dart';

final puntuacionControllerProvider =
    StateNotifierProvider<PuntuacionController, AsyncValue<List<Puntuacion>>>(
  (ref) => PuntuacionController(ref),
);

final puntuacionesListProvider = Provider<List<Puntuacion>>((ref) {
  return ref.watch(puntuacionControllerProvider).maybeWhen(
        data: (puntuaciones) => puntuaciones,
        orElse: () => [],
      );
});

final puntuacionLoadingProvider = Provider<bool>((ref) {
  return ref.watch(puntuacionControllerProvider).isLoading;
});

final puntuacionErrorProvider = Provider<String?>((ref) {
  return ref.watch(puntuacionControllerProvider).error?.toString();
});
