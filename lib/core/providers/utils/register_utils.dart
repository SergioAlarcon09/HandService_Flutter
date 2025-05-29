import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/presentations-auth/second_screen.dart';
import 'package:mysql_flutter_crud/core/presentations-auth/auth-widgets/pass_error.dart';
import 'package:mysql_flutter_crud/core/providers/register_provider.dart';

//! NO TOCAR

Future<void> register(
    BuildContext context,
    WidgetRef ref,
    TextEditingController userController,
    TextEditingController emailController,
    TextEditingController passwordController) async {
  await ref.read(registerProvider.notifier).register(
        context,
        userController.text,
        emailController.text,
        passwordController.text,
      );

  final token = ref.read(registerProvider);
  if (token != null && context.mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SecondScreen()),
    );
  } else if (context.mounted) {
    showErrorDialogPass(context);
  }
}
