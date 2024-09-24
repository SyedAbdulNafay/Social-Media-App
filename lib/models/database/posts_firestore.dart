import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  //select the current user
  final User? user = FirebaseAuth.instance.currentUser;

  //get collection of posts
  CollectionReference posts = FirebaseFirestore.instance.collection("posts");

  //add a post
  Future<void> addPost(String message) {
    return posts.add({
      'UserEmail': user!.email,
      'message': message,
      'timestamp': Timestamp.now(),
      'likes': []
    });
  }

  //read posts
  Future<QuerySnapshot> getPostsFuture() {
    final postsStream = FirebaseFirestore.instance
        .collection("posts")
        .orderBy('timestamp', descending: true)
        .get();
    return postsStream;
  }

  Stream<QuerySnapshot> getUserPostsStream() {
    final userPostsStream = FirebaseFirestore.instance
        .collection("posts")
        .where("UserEmail", isEqualTo: user!.email)
        .orderBy('timestamp', descending: true)
        .snapshots();
    return userPostsStream;
  }
}
