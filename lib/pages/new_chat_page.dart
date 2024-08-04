import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:social_media_app/models/message.dart';
import 'package:social_media_app/services/chat/chat_services.dart';
import 'package:social_media_app/widgets/chat_bubble.dart';
import 'package:social_media_app/widgets/my_message_button.dart';
import 'package:social_media_app/widgets/my_text_field.dart';
import 'package:swipe_to/swipe_to.dart';

import '../widgets/reply_message.dart';

class NewChatPage extends HookWidget {
  final String imageURL;
  final String userID;
  final String receiverUsername;
  final String receiverID;
  NewChatPage({
    super.key,
    required this.imageURL,
    required this.receiverID,
    required this.receiverUsername,
    required this.userID,
  });

  final ChatServices chatService = ChatServices();

  @override
  Widget build(BuildContext context) {
    final replyMessage = useState<Message?>(null);
    final messages = useStream(chatService.getMessages(
      FirebaseAuth.instance.currentUser!.uid,
      receiverID,
    ));

    final focusNode = useFocusNode();
    final _messageController = useTextEditingController();
    bool isReplying = replyMessage.value != null;
    bool _showOptions = false;
    Message? _optionsMessage;

    void sendMessage() async {
      if (_messageController.text.isNotEmpty) {
        String message = _messageController.text;
        _messageController.clear();
        await chatService.sendMessage(
          receiverID,
          message,
          replyMessage.value,
        );
        // cancelReply();
      }
    }
    // void replyMessage(Message message) {}

    void cancelReply() {}

    Widget _buildMessageItem(DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      bool isCurrentUser =
          data['senderId'] == FirebaseAuth.instance.currentUser!.uid;

      var alignment =
          isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

      Message message = Message(
        id: doc.id,
        replyMessage: data['replyMessage'],
        senderId: data['senderId'],
        senderEmail: data['senderEmail'],
        receiverId: data['receiverId'],
        message: data['message'],
        timestamp: data['timestamp'],
        status: data['status'],
      );

      return Stack(
        children: [
          SwipeTo(
            onRightSwipe: (details) {
              replyMessage.value = message;
              focusNode.requestFocus();
            },
            child: GestureDetector(
              child: Container(
                alignment: alignment,
                child: ChatBubble(
                  replyMessage: data['replyMessage'],
                  message: data['message'],
                  isCurrentUser: isCurrentUser,
                  timestamp: data['timestamp'],
                  status: data['status'],
                  showOptions: false,
                ),
              ),
            ),
          )
        ],
      );
    }

    Widget _buildMessageList(BuildContext context) {
      if (messages.data == null) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        );
      }

      return GestureDetector(
        onTap: () {
          focusNode.unfocus();
        },
        child: ListView(
          children:
              messages.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        ),
      );
    }

    // Widget _buildMessageList(BuildContext context) {
    //   String senderID = FirebaseAuth.instance.currentUser!.uid;
    //   return StreamBuilder(
    //       stream: chatService.getMessages(senderID, receiverID),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return Center(
    //             child: CircularProgressIndicator(
    //               color: Theme.of(context).colorScheme.inversePrimary,
    //             ),
    //           );
    //         }

    //         if (snapshot.hasError) {
    //           return Center(
    //             child: Text(snapshot.error.toString()),
    //           );
    //         }

    //         if (!snapshot.hasData) {
    //           return Container();
    //         }

    //         return GestureDetector(
    //           onTap: () {
    //             focusNode.unfocus();
    //           },
    //           child: ListView(
    //             children: snapshot.data!.docs
    //                 .map((doc) => _buildMessageItem(doc))
    //                 .toList(),
    //           ),
    //         );
    //       });
    // }

    Widget _buildReply(BuildContext context) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadiusDirectional.circular(5)),
            child: MyReplyMessage(
              message: replyMessage.value!,
              onCancelReply: () {
                replyMessage.value = null;
                focusNode.unfocus();
              },
            )),
      );
    }

    Widget _buildUserInput(BuildContext context, bool isReplying) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isReplying) _buildReply(context),
                MyTextField(
                  obscureText: false,
                  isReplying: isReplying,
                  focusNode: focusNode,
                  controller: _messageController,
                  hintText: "Type your message",
                )
              ],
            ),
          ),
          MyMessageButton(
            onTap: sendMessage,
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageURL != "not selected"
                ? CircleAvatar(
                    backgroundImage: NetworkImage(imageURL),
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
            Text(receiverUsername),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(context),
          ),
          _buildUserInput(context, isReplying),
        ],
      ),
    );
  }
}
