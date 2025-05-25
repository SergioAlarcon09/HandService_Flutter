import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/models/nivel_educativo_model.dart';
import 'package:mysql_flutter_crud/data/source/nivel_educativo_controller.dart';

final nivelEducativoControllerProvider = StateNotifierProvider<
    NivelEducativoController, AsyncValue<List<NivelEducativo>>>(
  (ref) => NivelEducativoController(ref),
);

final nivelesEducativosProvider = Provider<List<NivelEducativo>>((ref) {
  return ref.watch(nivelEducativoControllerProvider).maybeWhen(
        data: (niveles) => niveles,
        orElse: () => [],
      );
});

final nivelEducativoLoadingProvider = Provider<bool>((ref) {
  return ref.watch(nivelEducativoControllerProvider).isLoading;
});

final nivelEducativoErrorProvider = Provider<String?>((ref) {
  return ref.watch(nivelEducativoControllerProvider).error?.toString();
});
