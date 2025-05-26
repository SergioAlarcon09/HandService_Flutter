// lib/widgets/custom_input.dart
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  const CustomInput({
    super.key,
    required this.hintText,
    this.isPassword = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
