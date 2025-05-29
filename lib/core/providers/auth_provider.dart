import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/domain/notifiers/auth_notifier.dart';

//!NO TOCAR

final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier(ref);
});
