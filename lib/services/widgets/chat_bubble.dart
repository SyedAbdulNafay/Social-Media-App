import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/services/theme/theme_manager.dart';

class ChatBubble extends StatefulWidget {
  final bool showOptions;
  final Map<String, dynamic>? replyMessage;
  final String message;
  final bool isCurrentUser;
  final Timestamp timestamp;
  final String status;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
    required this.status,
    this.replyMessage,
    required this.showOptions,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final GlobalKey _replyKey = GlobalKey();
  double? _replyContainerWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureReplyContainer();
    });
  }

  void _measureReplyContainer() {
    final RenderBox? renderBox =
        _replyKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _replyContainerWidth = renderBox.size.width;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeManager theme = ThemeManager();
    DateTime dateTime = widget.timestamp.toDate();

    IconData statusIcon;
    Color? statusIconColor;

    switch (widget.status) {
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

    return Column(
      children: [
        if (widget.replyMessage != null)
          Container(
            key: _replyKey,
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            decoration: BoxDecoration(
                color: widget.isCurrentUser
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: widget.isCurrentUser
                              ? Colors.black
                              : Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                      width: 4,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.replyMessage!['senderEmail'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.replyMessage!['message'])
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        IntrinsicWidth(
          child: Container(
            width: widget.replyMessage != null ? _replyContainerWidth : null,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            padding: EdgeInsets.all(widget.replyMessage == null ? 15 : 8),
            decoration: BoxDecoration(
              borderRadius: widget.replyMessage == null
                  ? const BorderRadius.all(Radius.circular(12))
                  : const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
              color: widget.isCurrentUser
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message,
                  style: TextStyle(
                    color: theme.isDarkMode
                        ? widget.isCurrentUser
                            ? Colors.white
                            : Colors.white
                        : Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${dateTime.hour}:${dateTime.minute}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(
                      width: 4,
                    ),
                    widget.isCurrentUser
                        ? Icon(
                            statusIcon,
                            color: statusIconColor,
                            size: 16,
                          )
                        : Container()
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
