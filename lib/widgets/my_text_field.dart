import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? Function(String?)? validator;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  const MyTextField(
      {super.key,
      this.hintText,
      required this.obscureText,
      this.controller,
      this.validator,
      this.focusNode,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 10, top: 5, right: 20),
      child: TextFormField(
        onChanged: onChanged,
        autofocus: false,
        focusNode: focusNode,
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.inversePrimary)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface)),
            fillColor: Theme.of(context).colorScheme.primary,
            filled: true,
            hintText: hintText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}
