import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/database/posts_firestore.dart';
import 'package:social_media_app/pages/post_screen.dart';
import 'package:social_media_app/theme/theme_manager.dart';
import 'package:social_media_app/widgets/my_list_tile.dart';
import 'package:social_media_app/widgets/my_post_button.dart';
import 'package:social_media_app/widgets/my_text_field.dart';

import '../widgets/my_drawer.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late FocusNode _focusNode;
  final TextEditingController _postController = TextEditingController();

  final FirestoreDatabase database = FirestoreDatabase();

  void postMessage() {
    if (_postController.text.isNotEmpty) {
      database.addPost(_postController.text);
      _postController.clear();
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          foregroundColor: Colors.black,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PostScreen())),
          child: const Icon(Icons.post_add),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                  themeManager.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                themeManager.toggleTheme();
              },
            )
          ],
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          backgroundColor: Colors.transparent,
          title: const Center(
              child: Text(
            "C O N N E C T",
          )),
        ),
        drawer: const MyDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder(
                stream: database.getPostsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ));
                  }

                  final posts = snapshot.data!.docs;

                  if (snapshot.data == null || posts.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Text(
                          "No posts...get started!",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }

                  return Expanded(
                      child: ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];

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
                          }));
                }),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                      isReplying: false,
                      focusNode: _focusNode,
                      hintText: "Say something...",
                      obscureText: false,
                      controller: _postController),
                ),
                MyPostButton(
                  onTap: postMessage,
                  icon: const Icon(
                    Icons.arrow_circle_up,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
