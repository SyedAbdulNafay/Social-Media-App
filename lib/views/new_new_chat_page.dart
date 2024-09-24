import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/chat_controller.dart';
import 'package:swipe_to/swipe_to.dart';

import '../models/message.dart';
import '../services/widgets/chat_bubble.dart';
import '../services/widgets/my_message_button.dart';
import '../services/widgets/my_text_field.dart';
import '../services/widgets/reply_message.dart';

class NewNewChatPage extends StatelessWidget {
  final String imageURL;
  final String userID;
  final String receiverUsername;
  final String receiverID;
  const NewNewChatPage({
    super.key,
    required this.imageURL,
    required this.userID,
    required this.receiverUsername,
    required this.receiverID,
  });

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController(
        imageURL: imageURL,
        receiverID: receiverID,
        userID: userID,
        receiverUsername: receiverUsername));
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
                      color: Get.theme.colorScheme.inversePrimary,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
            Text(receiverUsername),
          ],
        ),
        backgroundColor: Get.theme.colorScheme.secondary,
      ),
      backgroundColor: Get.theme.colorScheme.surface,
      body: Column(
        children: [
          Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: chatController.messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = chatController.messages[index];
                      final fata = chatController.messages[index].data();
                      bool isCurrentUser = data['senderId'] ==
                          chatController.fba.currentUser!.uid;

                      var alignment = isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft;

                      Message message = Message(
                        id: data.id,
                        replyMessage: fata['replyMessage'],
                        senderId: fata['senderId'],
                        senderEmail: fata['senderEmail'],
                        receiverId: fata['receiverId'],
                        message: fata['message'],
                        timestamp: fata['timestamp'],
                        status: fata['status'],
                      );

                      return SwipeTo(
                        onRightSwipe: (details) {
                          chatController.replyMessage.value = message;
                          chatController.messageFocusNode.requestFocus();
                        },
                        child: Container(
                          alignment: alignment,
                          child: ChatBubble(
                            replyMessage: message.replyMessage,
                            message: message.message,
                            isCurrentUser: isCurrentUser,
                            timestamp: message.timestamp,
                            status: message.status,
                            showOptions: false,
                          ),
                        ),
                      );
                    },
                  ))),
          Obx(() => Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (chatController.replyMessage.value != null)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Get.theme.colorScheme.primary,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Get.theme.colorScheme.secondary,
                                    borderRadius:
                                        BorderRadiusDirectional.circular(5)),
                                child: MyReplyMessage(
                                  message: chatController.replyMessage.value!,
                                  onCancelReply: () {
                                    chatController.replyMessage.value = null;
                                  },
                                )),
                          ),
                        MyTextField(
                          obscureText: false,
                          isReplying: chatController.replyMessage.value != null,
                          focusNode: chatController.messageFocusNode,
                          controller: chatController.messageController,
                          hintText: "Type your message",
                        )
                      ],
                    ),
                  ),
                  MyMessageButton(
                    onTap: () {
                      chatController
                          .sendMessage(chatController.messageController.text);
                    },
                  )
                ],
              ))
        ],
      ),
    );
  }
}
