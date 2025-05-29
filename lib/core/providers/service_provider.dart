import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/source/service_controller.dart';
import '../../data/models/service_model.dart';


//!NO TOCAR

final serviceControllerProvider =
    StateNotifierProvider<ServiceController, AsyncValue<List<Service>>>(
  (ref) => ServiceController(ref),
);

final servicesProvider = serviceControllerProvider;