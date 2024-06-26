import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/theme/theme_manager.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final Timestamp timestamp;
  final String status;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.timestamp,
      required this.status});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    DateTime dateTime = timestamp.toDate();

    IconData statusIcon;
    Color? statusIconColor;

    switch (status) {
      case 'sending':
        statusIcon = Icons.access_time;
        statusIconColor = Colors.grey;
        break;
      case 'delivered':
        statusIcon = Icons.check;
        statusIconColor = Colors.grey;
        break;
      case 'seen':
        statusIcon = Icons.check;
        statusIconColor = Colors.blue[300];
        break;
      default:
        statusIcon = Icons.access_time;
        statusIconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: isCurrentUser
              ? Theme.of(context).colorScheme.inversePrimary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
                color: isCurrentUser
                    ? Colors.black
                    : (themeManager.isDarkMode ? Colors.white : Colors.black)),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                "${dateTime.hour}:${dateTime.minute}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(width: 4),
              isCurrentUser
                  ? Icon(
                      statusIcon,
                      color: statusIconColor,
                      size: 16,
                    )
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}
