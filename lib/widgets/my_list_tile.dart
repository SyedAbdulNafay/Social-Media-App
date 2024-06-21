import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailingText;
  const MyListTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.trailingText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            title,
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(trailingText,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary))
            ],
          ),
        ),
      ),
    );
  }
}
