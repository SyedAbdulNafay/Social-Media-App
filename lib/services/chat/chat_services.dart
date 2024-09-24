import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/message.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot>? _usersStream;

  Stream<QuerySnapshot> get usersStream {
    return _usersStream ??= _firestore.collection("Users").snapshots();
  }

  // get stream of users sorted by last message timestamp
  Stream<List<dynamic>> getUsersStream() {
    return _firestore.collection("Users").get().then((usersSnapshot) {
      final users = usersSnapshot.docs.map((doc) => doc.data()).toList();

      // get the last message timestamp for each user
      final futures = users.map((user) async {
        final chatroomId =
            getChatroomID(_auth.currentUser!.uid, user['userId']);
        final messagesSnapshot = await _firestore
            .collection("chat_rooms")
            .doc(chatroomId)
            .collection("messages")
            .orderBy("timestamp", descending: true)
            .limit(1)
            .get();

        final lastMessageTimestamp = messagesSnapshot.docs.isNotEmpty
            ? messagesSnapshot.docs.first.get("timestamp")
            : null;

        return {
          'user': user,
          'lastMessageTimestamp': lastMessageTimestamp,
        };
      });

      return Future.wait(futures).then((usersWithTimestamps) {
        // sort users by last message timestamp
        usersWithTimestamps.sort((a, b) {
          final timestampA = a['lastMessageTimestamp'] ?? Timestamp(0, 0);
          final timestampB = b['lastMessageTimestamp'] ?? Timestamp(0, 0);
          return timestampB.compareTo(timestampA);
        });

        return (usersWithTimestamps
            .map((userWithTimestamp) => userWithTimestamp['user'])
            .toList());
      });
    }).asStream();
  }

  //send message
  Future<void> sendMessage(
      String receiverId, String messageText, Message? replyMessage) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message message = Message(
        replyMessage: replyMessage?.toMap(),
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
      for (var doc in snapshot.docs) {
        doc.reference.update({'status': status});
      }
    });
  }

  String getChatroomID(String userID, String otherUserID) {
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

  Future<int> newMessages(String currentUserID, String otherUserID) async {
    String chatroomID = getChatroomID(currentUserID, otherUserID);
    final messages = await _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .get();
    int hasNewMessge = messages.docs.where((message) {
      return message.get('senderId') == otherUserID &&
          message.get('status') == 'delivered';
    }).length;

    return hasNewMessge;
  }
}
