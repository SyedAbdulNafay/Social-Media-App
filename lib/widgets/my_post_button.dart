import 'package:flutter/material.dart';

class MyPostButton extends StatelessWidget {
  final void Function()? onTap;
  const MyPostButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.secondary),
        child: Icon(
          Icons.arrow_circle_up,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
