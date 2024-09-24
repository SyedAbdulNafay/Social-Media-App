import 'package:flutter/material.dart';

class MyDeleteButton extends StatelessWidget {
  final void Function()? onTap;
  const MyDeleteButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.cancel,
      ),
    );
  }
}
