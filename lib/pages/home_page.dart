import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/database/posts_firestore.dart';
import 'package:social_media_app/widgets/my_list_tile.dart';
import 'package:social_media_app/widgets/my_post_button.dart';
import 'package:social_media_app/widgets/my_text_field.dart';

import '../widgets/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
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
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          "No posts...get started!",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 16),
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
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        focusNode: _focusNode,
                        hintText: "Say something...",
                        obscureText: false,
                        controller: _postController),
                  ),
                  MyPostButton(onTap: postMessage)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
