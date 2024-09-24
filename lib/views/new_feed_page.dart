import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:social_media_app/controllers/posts_controller.dart';

import '../services/widgets/my_list_tile.dart';

class NewFeedPage extends StatelessWidget {
  const NewFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PostsController controller = Get.put(PostsController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              Get.changeTheme(
                  Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
            },
          )
        ],
        backgroundColor: Colors.transparent,
        title: const Center(
            child: Text(
          "C O N N E C T",
        )),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        foregroundColor: Colors.black,
        backgroundColor: Get.theme.colorScheme.inversePrimary,
        onPressed: () => Get.to(() => const NewFeedPage()),
        child: const Icon(Icons.post_add),
      ),
      body: Obx(() => LiquidPullToRefresh(
            onRefresh: controller.getPosts,
            animSpeedFactor: 2,
            showChildOpacityTransition: false,
            height: 150,
            child: ListView.builder(
              itemCount: controller.posts.length,
              itemBuilder: (context, index) {
                final post = controller.posts[index];

                String message = post['message'];
                String email = post['UserEmail'];
                Timestamp timestamp = post['timestamp'];

                return MyListTile(
                  title: email,
                  subtitle: message,
                  timestamp: timestamp,
                  postId: post.id,
                  likes: List<String>.from(post['likes'] ?? []),
                );
              },
            ),
          )),
    );
  }
}
