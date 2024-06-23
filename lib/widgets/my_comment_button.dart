import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final String postId;
  final void Function()? onTap;
  const CommentButton({super.key, this.onTap, required this.postId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          const Icon(Icons.comment),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(postId)
                  .collection("comments")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.docs.length.toString(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  );
                } else {
                  return Text(
                    "",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  );
                }
              })
        ],
      ),
    );
  }
}
