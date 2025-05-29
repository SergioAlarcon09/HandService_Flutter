import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/presentations-auth/auth-widgets/auth_dialog.dart';
import 'package:mysql_flutter_crud/core/presentations-auth/second_screen.dart';
import 'package:mysql_flutter_crud/core/providers/auth_provider.dart';

//! NO TOCAR

Future<void> login(
  BuildContext context,
  WidgetRef ref,
  TextEditingController emailController,
  TextEditingController passwordController,
) async {
  await ref.read(authProvider.notifier).login(
    context,
    emailController.text,
    passwordController.text,
  );

  final isMonted = context.mounted;

  final token = ref.read(authProvider);
  if(token != null) {
    if (Navigator.of(context).mounted){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SecondScreen()),
        );
    }
  }else if(isMonted){
    showErrorDialog(context);
  }
}