import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/pages/chat_page.dart';
import 'package:social_media_app/pages/new_chat_page.dart';
import 'package:social_media_app/services/chat/chat_services.dart';

import '../widgets/my_user_tile.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final ChatServices chatService = ChatServices();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: StreamBuilder(
              stream: _auth.userChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.displayName ?? "");
                } else {
                  return const Text("");
                }
              },
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: StreamBuilder(
              stream: ChatServices().usersStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                if (snapshot.data != null) {
                  final users = snapshot.data!.docs;

                  return ListView(
                      children: users
                          .map((userData) =>
                              _buildUserListItem(userData, context))
                          .toList());
                } else {
                  return const Center(
                    child: Text("No users found"),
                  );
                }
              })),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: chatService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (snapshot.data != null) {
            return ListView(
              children: snapshot.data!
                  .map<Widget>(
                      (userData) => _buildUserListItem(userData, context))
                  .toList(),
            );
          } else {
            return const Center(
              child: Text("No users found"),
            );
          }
        });
  }

  Widget _buildUserListItem(
      QueryDocumentSnapshot userData, BuildContext context) {
    if (userData['email'] != FirebaseAuth.instance.currentUser!.email) {
      int hasNewMessage = 0;
      chatService
          .newMessages(_auth.currentUser!.uid, userData['userId'])
          .then((value) => hasNewMessage = value);
      return MyUserTile(
          hasNewMessage: hasNewMessage,
          imageURL: userData['profilePicture'],
          text: userData['username'],
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewChatPage(
                          imageURL: userData['profilePicture'],
                          userID: FirebaseAuth.instance.currentUser!.uid,
                          receiverUsername: userData['username'],
                          receiverID: userData['userId'],
                        )));
            setState(() {});
          });
    } else {
      return Container();
    }
  }
}
