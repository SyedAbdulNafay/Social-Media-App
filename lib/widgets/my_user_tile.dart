import 'package:flutter/material.dart';

class MyUserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MyUserTile({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary),
          child: Row(
            children: [
              Icon(Icons.person),
              SizedBox(
                width: 20,
              ),
              Text(text)
            ],
          ),
        ));
  }
}
