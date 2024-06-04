import 'package:flutter/material.dart';

class PassCustomTextField extends StatelessWidget {
  const PassCustomTextField(
      {super.key,
      required this.hint,
      required this.label,
      this.controller,
      this.isPassword = true,

      required this.obscure,
      });
  final String hint;
  final String label;
  final bool isPassword;
  final bool obscure;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure ? true : false,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          label: Text(label),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey, width: 1)
              ),
             ),
    );
  }
}