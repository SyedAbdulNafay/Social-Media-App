import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/widgets/my_comment_box.dart';
import '../services/widgets/my_post_button.dart';
import '../services/widgets/my_text_field.dart';

class PostController extends GetxController {
  var isLiked = false.obs;
  var likes = [];
  var comments = [].obs;
  final String postId;
  final Timestamp timestamp;
  late DateTime dateTime;
  late String formattedDate;
  final TextEditingController _commentController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  PostController({
    required this.likes,
    required this.postId,
    required this.timestamp,
  });

  void addComment(String currentText) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .add({
      "CommentText": currentText,
      "CommentedBy": currentUser!.email,
      "Timestamp": Timestamp.now()
    });
    _commentController.clear();
  }

  void toggleLike() {
    isLiked.value = !isLiked.value;

    final DocumentReference postRef =
        FirebaseFirestore.instance.collection("posts").doc(postId);

    if (isLiked.value) {
      postRef.update({
        'likes': FieldValue.arrayUnion([currentUser!.email])
      });
    } else {
      postRef.update({
        'likes': FieldValue.arrayRemove([currentUser!.email])
      });
    }
  }

  void deletePost() {
    Get.dialog(AlertDialog(
      title: const Text("Delete Post"),
      content: const Text("Are you sure you want to delete post?"),
      actions: [
        TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
                foregroundColor: WidgetStateProperty.all(Colors.white)),
            onPressed: () async {
              comments.clear();
              final commentDocs = await FirebaseFirestore.instance
                  .collection("posts")
                  .doc(postId)
                  .collection("comments")
                  .get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("posts")
                    .doc(postId)
                    .collection("comments")
                    .doc(doc.id)
                    .delete();
              }

              FirebaseFirestore.instance
                  .collection("posts")
                  .doc(postId)
                  .delete()
                  .then((value) => debugPrint("post deleted"))
                  .catchError(
                      (error) => debugPrint("failed to delete post: $error"));
              Get.back();
            },
            child: const Text("Yes")),
        TextButton(
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Get.theme.colorScheme.primary),
                foregroundColor:
                    WidgetStateProperty.all(Get.theme.colorScheme.secondary)),
            onPressed: () => Get.back(),
            child: const Text("No")),
      ],
    ));
  }

  Future<void> openCommentSection() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .orderBy("Timestamp", descending: true)
        .get();
    comments.value = querySnapshot.docs;
    await Get.bottomSheet(
      Padding(
        padding: Get.mediaQuery.viewInsets,
        child: Container(
            height: Get.mediaQuery.size.height * 0.7,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Get.theme.colorScheme.surface),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text("Comments"),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                          child: comments.isEmpty
                              ? Center(
                                  child: Text(
                                    "No comments... start a conversation",
                                    style: TextStyle(
                                        color: Get
                                            .theme.colorScheme.inversePrimary),
                                  ),
                                )
                              : ListView(
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: comments.map((doc) {
                                    final commentData = doc.data();

                                    return MyCommentBox(
                                        text: commentData["CommentText"],
                                        user: commentData["CommentedBy"],
                                        timestamp: commentData["Timestamp"]);
                                  }).toList(),
                                )),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyTextField(
                        isReplying: false,
                        obscureText: false,
                        hintText: "Enter comment here...",
                        controller: _commentController,
                      ),
                    ),
                    MyPostButton(
                      onTap: () => addComment(_commentController.text),
                      icon: const Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      isScrollControlled: true,
    );
  }

  @override
  void onInit() {
    super.onInit();
    isLiked.value = likes.contains(currentUser!.email);
    dateTime = timestamp.toDate();
    formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
}
