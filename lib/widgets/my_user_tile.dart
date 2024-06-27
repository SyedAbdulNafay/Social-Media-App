import 'package:flutter/material.dart';

class MyUserTile extends StatelessWidget {
  final String text;
  final String imageURL;
  final void Function()? onTap;
  final int hasNewMessage;
  const MyUserTile(
      {super.key,
      required this.text,
      this.onTap,
      required this.imageURL,
      required this.hasNewMessage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  imageURL != "not selected"
                      ? CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(imageURL),
                        )
                      : const Icon(Icons.person),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              hasNewMessage > 0
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          shape: BoxShape.circle),
                      child: Text(hasNewMessage.toString()),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
