import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/my_comment_box.dart';
import 'package:social_media_app/widgets/my_comment_button.dart';
import 'package:social_media_app/widgets/my_delete_button.dart';
import 'package:social_media_app/widgets/my_like_button.dart';
import 'package:social_media_app/widgets/my_post_button.dart';
import 'package:social_media_app/widgets/my_text_field.dart';

class MyListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final Timestamp timestamp;
  final String postId;
  final List<String> likes;
  const MyListTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.timestamp,
      required this.postId,
      required this.likes});

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  final TextEditingController _commentController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
  }

  void addComment(String currentText) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.postId)
        .collection("comments")
        .add({
      "CommentText": currentText,
      "CommentedBy": currentUser!.email,
      "Timestamp": Timestamp.now()
    });
    _commentController.clear();
  }

  void openCommentSection() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background),
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
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(widget.postId)
                                    .collection("comments")
                                    .orderBy("Timestamp", descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary));
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        "Error: ${snapshot.error}",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary),
                                      ),
                                    );
                                  }
                                  if (snapshot.data == null) {
                                    return Center(
                                      child: Text(
                                        "No comments... start a conversation",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary),
                                      ),
                                    );
                                  }
                                  return ListView(
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    children: snapshot.data!.docs.map((doc) {
                                      final commentData = doc.data();

                                      return MyCommentBox(
                                          text: commentData["CommentText"],
                                          user: commentData["CommentedBy"],
                                          timestamp: commentData["Timestamp"]);
                                    }).toList(),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MyTextField(
                            obscureText: false,
                            hintText: "Enter comment here...",
                            controller: _commentController,
                          ),
                        ),
                        MyPostButton(
                          onTap: () => addComment(_commentController.text),
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    )
                  ],
                )),
          );
        });
  }

  void deletePost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Post"),
              content: const Text("Are you sure you want to delete post?"),
              actions: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        foregroundColor: WidgetStateProperty.all(Colors.white)),
                    onPressed: () async {
                      final commentDocs = await FirebaseFirestore.instance
                          .collection("posts")
                          .doc(widget.postId)
                          .collection("comments")
                          .get();

                      for (var doc in commentDocs.docs) {
                        await FirebaseFirestore.instance
                            .collection("posts")
                            .doc(widget.postId)
                            .collection("comments")
                            .doc(doc.id)
                            .delete();
                      }

                      FirebaseFirestore.instance
                          .collection("posts")
                          .doc(widget.postId)
                          .delete()
                          .then((value) => print("post deleted"))
                          .catchError((error) =>
                              print("failed to delete post: $error"));
                      Navigator.pop(context);
                    },
                    child: const Text("Yes")),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        foregroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.secondary)),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("No")),
              ],
            ));
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    final DocumentReference postRef =
        FirebaseFirestore.instance.collection("posts").doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'likes': FieldValue.arrayUnion([currentUser!.email])
      });
    } else {
      postRef.update({
        'likes': FieldValue.arrayRemove([currentUser!.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.timestamp.toDate();
    String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';

    return Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  if (widget.title == currentUser!.email)
                    MyDeleteButton(
                      onTap: deletePost,
                    )
                ],
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          content: SingleChildScrollView(
                            child: SizedBox(
                                height: 700, child: Text(widget.subtitle)),
                          ),
                          actions: [
                            TextButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                        Theme.of(context).colorScheme.primary),
                                    foregroundColor: WidgetStateProperty.all(
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Close"))
                          ],
                        );
                      });
                },
                child: Text(
                  widget.subtitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          MyLikeButton(isLiked: isLiked, onTap: toggleLike),
                          Text(
                            widget.likes.length.toString(),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          CommentButton(
                            postId: widget.postId,
                            onTap: openCommentSection,
                          ),
                        ],
                      )
                    ],
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
