import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/services/chat/chat_services.dart';
import 'package:social_media_app/widgets/chat_bubble.dart';
import 'package:social_media_app/widgets/my_message_button.dart';
import 'package:social_media_app/widgets/my_text_field.dart';

class ChatPage extends StatefulWidget {
  final String userID;
  final String receiverUsername;
  final String receiverID;
  const ChatPage(
      {super.key,
      required this.receiverUsername,
      required this.receiverID,
      required this.userID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatServices chatService = ChatServices();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String messageText = _messageController.text;
      _messageController.clear();
      await chatService.sendMessage(widget.receiverID, messageText);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
    return Scaffold(
      appBar: AppBar(
        title: Align(
            alignment: const Alignment(-0.25, 0),
            child: Text(
              widget.receiverUsername,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            )),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          _buildMessageList(context),
          Align(
              alignment: const Alignment(0, 1), child: _buildUserInput(context))
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

          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser =
        data['senderId'] == FirebaseAuth.instance.currentUser!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: ChatBubble(
          timestamp: data['timestamp'],
          isCurrentUser: isCurrentUser,
          message: data['message'],
          status: data['status'],
        ));
  }

  Widget _buildUserInput(BuildContext context) {
    return Row(children: [
      Expanded(
          child: MyTextField(
        obscureText: false,
        controller: _messageController,
        hintText: "Type a message",
      )),
      MyMessageButton(
        onTap: sendMessage,
      ),
    ]);
  }
}
