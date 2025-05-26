import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/solicitud_model.dart';
import '../../data/source/solicitud_controller.dart';

final solicitudControllerProvider = StateNotifierProvider<SolicitudController,
    AsyncValue<List<SolicitudServicio>>>(
  (ref) => SolicitudController(ref),
);

final solicitudesListProvider = Provider<List<SolicitudServicio>>((ref) {
  return ref.watch(solicitudControllerProvider).maybeWhen(
        data: (solicitudes) => solicitudes,
        orElse: () => [],
      );
});

final solicitudLoadingProvider = Provider<bool>((ref) {
  return ref.watch(solicitudControllerProvider).maybeWhen(
        loading: () => true,
        orElse: () => false,
      );
});

final solicitudErrorProvider = Provider<String?>((ref) {
  return ref.watch(solicitudControllerProvider).maybeWhen(
        error: (error, _) => error.toString(),
        orElse: () => null,
      );
});
