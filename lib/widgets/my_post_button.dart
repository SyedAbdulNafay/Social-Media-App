import 'package:flutter/material.dart';

class MyPostButton extends StatelessWidget {
  final void Function()? onTap;
  final Icon icon;
  const MyPostButton({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 5, right: 10, bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.inversePrimary),
        child: icon,
      ),
    );
  }
}
