import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/models/message.dart';
import 'package:social_media_app/services/chat/chat_services.dart';

class ChatController extends GetxController {
  final ChatServices cs = ChatServices();
  final FirebaseAuth fba = FirebaseAuth.instance;
  final String imageURL;
  final String userID;
  final String receiverUsername;
  final String receiverID;
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();

  ChatController({
    required this.imageURL,
    required this.receiverID,
    required this.userID,
    required this.receiverUsername,
  });

  var messages = [].obs;
  var replyMessage = Rxn<Message?>();

  Future<void> getMessages() async {
    cs.getMessages(userID, receiverID).listen((messageSnapshot) {
      messages.value = messageSnapshot.docs;
    });
  }

  Future<void> sendMessage(String message) async {
    await cs.sendMessage(receiverID, message, replyMessage.value);
  }

  void setReplyMessage(Message? message) {
    replyMessage.value = message;
  }

  @override
  void onInit() {
    super.onInit();
    getMessages();
  }
}
