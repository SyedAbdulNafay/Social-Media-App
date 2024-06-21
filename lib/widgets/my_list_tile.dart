import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/my_like_button.dart';

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
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 20),
                  )
                ],
              ),
              Column(
                children: [
                  MyLikeButton(isLiked: isLiked, onTap: toggleLike),
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              )
            ],
          )
          // ListTile(
          //   title: Text(
          //     widget.title,
          //   ),
          //   subtitle: Text(
          //     widget.subtitle,
          //     style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          //   ),
          //   trailing: Column(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       MyLikeButton(isLiked: isLiked, onTap: toggleLike),
          //       // const SizedBox(
          //       //   height: 4,
          //       // ),
          //       Text(
          //         widget.likes.length.toString(),
          //         style:
          //             TextStyle(color: Theme.of(context).colorScheme.secondary),
          //       ),
          //       Text(formattedDate,
          //           style:
          //               TextStyle(color: Theme.of(context).colorScheme.secondary))
          //     ],
          //   ),
          // ),
          ),
    );
  }
}
