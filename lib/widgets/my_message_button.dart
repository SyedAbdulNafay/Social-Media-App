import 'package:flutter/material.dart';

class MyMessageButton extends StatelessWidget {
  final void Function()? onTap;
  const MyMessageButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10, bottom: 10, top: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.inversePrimary),
        child: const Icon(
          Icons.arrow_upward_rounded,
          color: Colors.black,
        ),
      ),
    );
  }
}
