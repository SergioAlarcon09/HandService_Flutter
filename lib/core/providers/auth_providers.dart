import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/data/source/auth_user_controller.dart';

import '../../data/models/auth_user_model.dart';

// 1. Provider del controlador de autenticación (StateNotifier)
final authUserControllerProvider =
    StateNotifierProvider<AuthUserController, AsyncValue<AuthUser?>>(
  (ref) => AuthUserController(ref),
);

// 2. Provider para acceder al usuario actual
final currentUserProvider = Provider<AuthUser?>((ref) {
  return ref.watch(authUserControllerProvider).value;
});

// 3. Provider para verificar estado de autenticación
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authUserControllerProvider).value != null;
});

// 4. Provider para estado de carga
final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authUserControllerProvider).isLoading;
});

// 5. Provider para errores de autenticación
final authErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(authUserControllerProvider);
  return state.hasError ? state.error.toString() : null;
});
