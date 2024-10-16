import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/post_controller.dart';

import 'my_comment_button.dart';
import 'my_delete_button.dart';
import 'my_like_button.dart';

class MyNewListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Timestamp timestamp;
  final String postId;
  final List<String> likes;
  const MyNewListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.postId,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.put(PostController(
      likes: likes,
      postId: postId,
      timestamp: timestamp,
    ));
    return Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Get.theme.colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                  ),
                  if (title == postController.currentUser!.email)
                    MyDeleteButton(
                      onTap: postController.deletePost,
                    )
                ],
              ),
              GestureDetector(
                onTap: () async {
                  await Get.dialog(AlertDialog(
                    title: Text(
                      title,
                      style: TextStyle(
                          fontSize: 15, color: Get.theme.colorScheme.secondary),
                    ),
                    content: SingleChildScrollView(
                      child: SizedBox(height: 700, child: Text(subtitle)),
                    ),
                    actions: [
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Get.theme.colorScheme.primary),
                              foregroundColor: WidgetStateProperty.all(
                                  Get.theme.colorScheme.secondary)),
                          onPressed: () => Get.back(),
                          child: const Text("Close"))
                    ],
                  ));
                },
                child: Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 20),
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
                          MyLikeButton(
                              isLiked: postController.isLiked.value,
                              onTap: postController.toggleLike),
                          Text(
                            likes.length.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          CommentButton(
                            postId: postId,
                            onTap: postController.openCommentSection,
                          ),
                        ],
                      )
                    ],
                  ),
                  Text(
                    postController.formattedDate,
                    style: TextStyle(color: Get.theme.colorScheme.secondary),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
