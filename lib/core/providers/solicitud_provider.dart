import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/models/solicitud_servicio_model.dart';
import 'package:mysql_flutter_crud/data/source/solicitud_controller.dart';

final solicitudControllerProvider =
    StateNotifierProvider<SolicitudController, AsyncValue<List<Solicitud>>>(
  (ref) => SolicitudController(ref),
);

final solicitudProvider = solicitudControllerProvider;