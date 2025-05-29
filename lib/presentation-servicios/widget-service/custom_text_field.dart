import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final String? prefixText;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.prefixText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: maxLines,
            obscureText: obscureText,
            decoration: InputDecoration(
              prefixText: prefixText,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}