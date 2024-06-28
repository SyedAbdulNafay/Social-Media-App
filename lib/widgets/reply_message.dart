import 'package:flutter/material.dart';
import 'package:social_media_app/models/message.dart';

class MyReplyMessage extends StatelessWidget {
  final Message message;
  final VoidCallback onCancelReply;
  const MyReplyMessage(
      {super.key, required this.message, required this.onCancelReply});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 4,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    message.senderEmail,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: onCancelReply,
                    child: const Icon(
                      Icons.close,
                      size: 16,
                    ),
                  )
                ],
              ),
              Text(message.message)
            ],
          ))
        ],
      ),
    );
  }
}
