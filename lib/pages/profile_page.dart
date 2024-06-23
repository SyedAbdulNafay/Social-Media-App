import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/database/posts_firestore.dart';
import 'package:social_media_app/widgets/my_list_tile.dart';
import 'package:social_media_app/widgets/my_text_box.dart';
import 'package:social_media_app/widgets/my_text_field.dart';

import '../widgets/my_back_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirestoreDatabase database = FirestoreDatabase();

  final usersCollection = FirebaseFirestore.instance.collection("Users");

  Future<void> editField(String field) async {
    String newString = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Edit $field",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              content: MyTextField(
                hintText: "Enter new $field",
                obscureText: false,
                onChanged: (value) {
                  newString = value;
                },
              ),
              actions: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        foregroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.secondary)),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        foregroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.secondary)),
                    onPressed: () => Navigator.of(context).pop(newString),
                    child: const Text("Save")),
              ],
            ));

    if (newString.trim().length > 0) {
      await usersCollection.doc(currentUser!.email).update({field: newString});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.inversePrimary),
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              Map<String, dynamic> user =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(top: 50, left: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          MyBackButton(),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Theme.of(context).colorScheme.primary),
                        padding: const EdgeInsets.all(25),
                        child: const Icon(
                          Icons.person,
                          size: 64,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(user['username'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        user['email'],
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: Text("My Details")),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextBox(
                        title: "Username",
                        content: user['username'],
                        onPressed: () => editField('username'),
                      ),
                      MyTextBox(
                        title: "Bio",
                        content: user['bio'],
                        onPressed: () => editField('bio'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Text("My Posts"),
                        ],
                      ),
                      StreamBuilder(
                          stream: database.getUserPostsStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              );
                            }
                            if (snapshot.hasError) {
                              Center(
                                child: Text("Error: ${snapshot.error}"),
                              );
                            }
                            final posts = snapshot.data?.docs;
                            if (posts == null || posts.isEmpty) {
                              return Center(
                                child: Text(
                                  "No posts...",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              );
                            }
                            return Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 300,
                              child: ListView.builder(
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) {
                                    final post = posts[index];
                                    return MyListTile(
                                        title: post['UserEmail'],
                                        subtitle: post['message'],
                                        timestamp: post['timestamp'],
                                        postId: post.id,
                                        likes: List<String>.from(
                                            post['likes'] ?? []));
                                  }),
                            );
                          })
                    ],
                  ),
                ),
              );
            } else {
              return const Text("No data");
            }
          },
        ),
      ),
    );
  }
}
