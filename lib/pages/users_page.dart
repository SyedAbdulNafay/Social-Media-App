import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/pages/chat_page.dart';
import 'package:social_media_app/services/chat/chat_services.dart';
import 'package:social_media_app/widgets/my_back_button.dart';

import '../widgets/my_user_tile.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  final ChatServices chatService = ChatServices();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            const Row(
              children: [
                MyBackButton(),
              ],
            ),
            Expanded(child: _buildUserList()),
          ],
        ),
      ),
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

          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != FirebaseAuth.instance.currentUser!.email) {
      return MyUserTile(
        imageURL: userData['profilePicture'],
        text: userData['username'],
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      imageURL: userData['profilePicture'],
                      userID: FirebaseAuth.instance.currentUser!.uid,
                      receiverUsername: userData['username'],
                      receiverID: userData['userId'],
                    ))),
      );
    } else {
      return Container();
    }
  }
}
