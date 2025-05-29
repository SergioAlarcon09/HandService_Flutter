import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mysql_flutter_crud/core/presentations-auth/auth-widgets/pass_error.dart';
import 'package:mysql_flutter_crud/core/providers/auth_storage.dart';
import 'package:mysql_flutter_crud/core/providers/auth-services/auth_services.dart';

//! NO TOCAR

class RegisterNotifier extends StateNotifier<String?> {
  final Ref ref;
  final AuthService _authService;

  RegisterNotifier(this.ref)
      : _authService = AuthService(),
        super(null);

  Future<void> register(BuildContext context, String name, String email,
      String password) async {
    final token = await _authService.register(name, email, password);
    if (token != null) {
      state = token;
      await AuthStorage().saveToken(token);
    } else {
      if (context.mounted) {
        showErrorDialogPass(context);
      }
    }
  }
}
