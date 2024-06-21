import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  //select the current user
  final User? user = FirebaseAuth.instance.currentUser;

  //get collection of posts
  final CollectionReference posts =
      FirebaseFirestore.instance.collection("posts");

  //add a post
  Future<void> addPost(String message) {
    return posts.add({
      'UserEmail': user!.email,
      'message': message,
      'timestamp': Timestamp.now()
    });
  }

  //read posts
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection("posts")
        .orderBy('timestamp', descending: true)
        .snapshots();
    return postsStream;
  }
}
