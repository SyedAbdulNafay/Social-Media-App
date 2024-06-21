import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? Function(String?)? validator;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode focusNode;
  const MyTextField(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.validator,
      required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.background)),
          fillColor: Theme.of(context).colorScheme.primary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
    );
  }
}
