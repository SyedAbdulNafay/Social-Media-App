import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/models/database/posts_firestore.dart';
import 'package:social_media_app/services/widgets/my_list_tile.dart';
import 'package:social_media_app/services/widgets/my_text_box.dart';
import 'package:social_media_app/services/widgets/my_text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirestoreDatabase database = FirestoreDatabase();

  final usersCollection = FirebaseFirestore.instance.collection("Users");
  XFile? image;
  UploadTask? uploadTask;

  selectImage() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picture != null) {
      setState(() {
        image = picture;
      });
    }
  }

  saveProfile() async {
    if (image == null) return;
    final ref = FirebaseStorage.instance.ref().child("images/${image!.name}");

    uploadTask = ref.putFile(File(image!.path));

    setState(() {});

    final snapshot = await uploadTask!.whenComplete(() => null);
    setState(() {
      uploadTask = null;
    });
    final downloadURL = await snapshot.ref.getDownloadURL();

    await usersCollection
        .doc(currentUser!.uid)
        .update({'profilePicture': downloadURL});
  }

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
                isReplying: false,
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

    if (newString.trim().isNotEmpty) {
      await usersCollection.doc(currentUser!.email).update({field: newString});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.inversePrimary),
              );
            }
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("no data"),
              );
            }
            Map<String, dynamic> user =
                snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Stack(alignment: Alignment.center, children: [
                    uploadTask != null
                        ? StreamBuilder(
                            stream: uploadTask?.snapshotEvents,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                debugPrint("snapshot has data");
                                final data = snapshot.data!;
                                double progress =
                                    data.bytesTransferred / data.totalBytes;

                                return SizedBox(
                                  height: 137,
                                  width: 137,
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    value: progress,
                                    strokeWidth: 8,
                                  ),
                                );
                              } else {
                                debugPrint("snapshot does not have data");
                                return SizedBox(
                                  height: 137,
                                  width: 137,
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    strokeWidth: 8,
                                  ),
                                );
                              }
                            })
                        : Container(),
                    Stack(alignment: Alignment.bottomRight, children: [
                      user['profilePicture'] != 'not selected'
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  NetworkImage(user['profilePicture']),
                            )
                          : Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary),
                              child: Icon(
                                Icons.person,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 64,
                              ),
                            ),
                      GestureDetector(
                        onTap: () async {
                          await selectImage();
                          await saveProfile();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.surface),
                          child: const Icon(
                            Icons.edit,
                          ),
                        ),
                      )
                    ]),
                  ]),
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
                  ),
                  const Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 25, left: 25),
                          child: Text("My Details")),
                    ],
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
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Text("My Posts"),
                      ),
                    ],
                  ),
                  StreamBuilder(
                      stream: database.getUserPostsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          );
                        }
                        if (snapshot.hasError) {
                          Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        }
                        final posts = snapshot.data?.docs;
                        if (posts == null || posts.isEmpty) {
                          return const Center(
                            child: Text(
                              "No posts...",
                            ),
                          );
                        }
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
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
                                    likes:
                                        List<String>.from(post['likes'] ?? []));
                              }),
                        );
                      })
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildProgress() {
    return StreamBuilder(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;

            return SizedBox(
              height: 137,
              width: 137,
              child: CircularProgressIndicator(
                color: Colors.green[800],
                value: progress,
                strokeWidth: 8,
              ),
            );
          }
          return Container();
        });
  }
}
