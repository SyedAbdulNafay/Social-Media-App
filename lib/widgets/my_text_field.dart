import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final bool isReplying;
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
      this.onChanged,
      required this.isReplying});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
      child: TextFormField(
        cursorColor: Theme.of(context).colorScheme.inversePrimary,
        onChanged: onChanged,
        autofocus: false,
        focusNode: focusNode,
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: isReplying
                ? const BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))
                : BorderRadius.circular(15),
          ),
          fillColor: Theme.of(context).colorScheme.primary,
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
