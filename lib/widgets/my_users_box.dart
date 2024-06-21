import 'package:flutter/material.dart';

class MyUsersBox extends StatelessWidget {
  final String username;
  final String email;
  const MyUsersBox({super.key, required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(bottom: 290, top: 210),
        height: 200,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Theme.of(context).colorScheme.background),
              padding: const EdgeInsets.all(25),
              child: const Icon(
                Icons.person,
                size: 64,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(username,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(
              height: 10,
            ),
            Text(
              email,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
