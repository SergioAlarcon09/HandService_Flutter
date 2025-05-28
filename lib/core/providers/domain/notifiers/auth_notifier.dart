import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/presentations/auth-widgets/auth_dialog.dart';
import 'package:mysql_flutter_crud/core/providers/auth_storage.dart';
import 'package:mysql_flutter_crud/core/providers/auth-services/auth_services.dart';

class AuthNotifier extends StateNotifier<String?> {
  final Ref ref;
  final AuthService _authService; //Declarar _authService como una variable de instancia

  AuthNotifier(this.ref)
      : _authService = AuthService(),
        super(null);

  Future<void> login(
      BuildContext context, String email, String password) async {
    final token =
        await _authService.login(email, password); // Acceder a _authService
    if (token != null) {
      state = token;
      await AuthStorage().saveToken(token);
    } else {
      if (context.mounted) {
        showErrorDialog(context);
      }
    }
  }
}
