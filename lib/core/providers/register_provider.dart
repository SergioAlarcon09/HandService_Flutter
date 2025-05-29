import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/providers/domain/notifiers/register_notifier.dart';

//! NO TOCAR

final registerProvider =
    StateNotifierProvider<RegisterNotifier, String?>((ref) {
  return RegisterNotifier(ref);
});
