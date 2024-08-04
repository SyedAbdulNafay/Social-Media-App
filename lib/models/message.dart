import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String status;
  final Map<String, dynamic>? replyMessage;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.status = 'sending',
    this.replyMessage,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'status': status,
      if (replyMessage != null) 'replyMessage': replyMessage,
    };
  }
}
