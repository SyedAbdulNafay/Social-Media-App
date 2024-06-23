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
      this.focusNode, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: TextFormField(
        onChanged: onChanged,
        autofocus: false,
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
      ),
    );
  }
}
