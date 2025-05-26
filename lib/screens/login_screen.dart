// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_input.dart';
import '../router/app_router.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 120), // opcional según tu UI
            const SizedBox(height: 32),
            CustomInput(
              hintText: 'Correo electrónico',
              controller: emailController,
            ),
            const SizedBox(height: 16),
            CustomInput(
              hintText: 'Contraseña',
              isPassword: true,
              controller: passwordController,
            ),
            const SizedBox(height: 24),
            authProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      final email = emailController.text.trim();
                      final pass = passwordController.text;

                      final success = await authProvider.login(email, pass);
                      if (success) {
                        Navigator.pushReplacementNamed(
                            context, AppRouter.homeRoute);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text(authProvider.errorMessage ?? 'Error')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Iniciar sesión'),
                  ),
          ],
        ),
      ),
    );
  }
}
