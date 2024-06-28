import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/message.dart';
import 'package:social_media_app/services/chat/chat_services.dart';
import 'package:social_media_app/widgets/chat_bubble.dart';
import 'package:social_media_app/widgets/my_message_button.dart';
import 'package:social_media_app/widgets/my_text_field.dart';
import 'package:social_media_app/widgets/reply_message.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatPage extends StatefulWidget {
  final String imageURL;
  final String userID;
  final String receiverUsername;
  final String receiverID;
  const ChatPage(
      {super.key,
      required this.receiverUsername,
      required this.receiverID,
      required this.userID,
      required this.imageURL});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final focusNode = FocusNode();
  Message? replyMessage;
  final TextEditingController _messageController = TextEditingController();

  final ChatServices chatService = ChatServices();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String messageText = _messageController.text;
      _messageController.clear();
      await chatService.sendMessage(
          widget.receiverID, messageText, replyMessage);
      setState(() {
        replyMessage = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _markMessageAsSeen();
  }

  void _markMessageAsSeen() async {
    String chatroomID =
        chatService.getChatroomID(widget.userID, widget.receiverID);
    await chatService.markMessagesAsSeen(chatroomID, widget.receiverID);
  }

  @override
  Widget build(BuildContext context) {
    bool isReplying = replyMessage != null;
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: const Alignment(-0.25, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.imageURL != "not selected"
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(widget.imageURL),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.inversePrimary),
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              Text(widget.receiverUsername),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(child: _buildMessageList(context)),
          Align(
              alignment: const Alignment(0, 1),
              child: _buildUserInput(context, isReplying))
        ],
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    String senderID = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        stream: chatService.getMessages(senderID, widget.receiverID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return Container();
          }

          return GestureDetector(
            onTap: () => focusNode.unfocus(),
            child: ListView(
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList(),
            ),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser =
        data['senderId'] == FirebaseAuth.instance.currentUser!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return SwipeTo(
      onRightSwipe: (details) {
        replyToMessage(Message(
            replyMessage: data['replyMessage'],
            senderId: data['senderId'],
            senderEmail: data['senderEmail'],
            receiverId: data['receiverId'],
            message: data['message'],
            timestamp: data['timestamp']));
        focusNode.requestFocus();
      },
      child: Container(
          alignment: alignment,
          child: ChatBubble(
            replyMessage: data['replyMessage'],
            timestamp: data['timestamp'],
            isCurrentUser: isCurrentUser,
            message: data['message'],
            status: data['status'],
          )),
    );
  }

  Widget _buildUserInput(BuildContext context, bool isReplying) {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isReplying) _buildReply(),
          MyTextField(
            isReplying: isReplying,
            focusNode: focusNode,
            obscureText: false,
            controller: _messageController,
            hintText: "Type a message",
          ),
        ],
      )),
      MyMessageButton(
        onTap: sendMessage,
      ),
    ]);
  }

  Widget _buildReply() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: MyReplyMessage(
        message: replyMessage!,
        onCancelReply: cancelReply,
      ));

  void replyToMessage(Message message) {
    setState(() {
      replyMessage = message;
    });
  }

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }
}
