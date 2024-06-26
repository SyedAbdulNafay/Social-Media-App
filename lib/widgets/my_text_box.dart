import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String title;
  final String content;
  final void Function()? onPressed;
  const MyTextBox(
      {super.key,
      required this.title,
      required this.content,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 20, left: 20),
      padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16, top: 8),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
              ),
              IconButton(
                  onPressed: onPressed,
                  icon: const Icon(
                    Icons.settings,
                  ))
            ],
          ),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
