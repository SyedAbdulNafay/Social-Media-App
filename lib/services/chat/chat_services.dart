import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/message.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get stream of users
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // get individual user
        final user = doc.data();

        // return that user
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverId, String messageText) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message message = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: messageText,
        timestamp: timestamp,
        status: 'sending');

    //construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids (this ensures the chatroom ID is the same for the any two people)

    String chatroomID = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .add(message.toMap());
    await updateMessageStatus(chatroomID, message.timestamp, 'delivered');
  }

  Future<void> updateMessageStatus(
      String chatroomID, Timestamp timestamp, String status) async {
    await _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .where("timestamp", isEqualTo: timestamp)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference.update({'status': status});
      });
    });
  }

  String getChatroomID(String userID, String otherUserID){
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatroomID = ids.join('_');
    return chatroomID;
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    //construct a chatroom id for both users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatroomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<void> markMessagesAsSeen(String chatroomID, String otherUserID) async {
    final messagesRef = _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .where("senderId", isEqualTo: otherUserID);
    await messagesRef.get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        document.reference.update({'status': 'seen'});
      }
    });
  }
}
