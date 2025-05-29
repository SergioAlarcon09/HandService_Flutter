import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/models/prestador_servicios_model.dart';
import 'package:mysql_flutter_crud/data/source/prestador_servicios_controller.dart';

final prestadorControllerProvider =
    StateNotifierProvider<PrestadorController, AsyncValue<List<Prestador>>>(
  (ref) => PrestadorController(ref),
);

final prestadoresProvider = prestadorControllerProvider;