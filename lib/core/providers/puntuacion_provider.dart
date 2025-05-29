import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/models/puntuacion_model.dart';
import 'package:mysql_flutter_crud/data/source/puntuacion_controller.dart';

final puntuacionControllerProvider =
    StateNotifierProvider<PuntuacionController, AsyncValue<List<Puntuacion>>>(
  (ref) => PuntuacionController(ref),
);

final puntuacionProvider = puntuacionControllerProvider;