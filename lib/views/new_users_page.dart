import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/users_controller.dart';
import 'package:social_media_app/views/new_new_chat_page.dart';

import '../services/widgets/my_user_tile.dart';

class NewUsersPage extends StatelessWidget {
  const NewUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersController controller = Get.put(UsersController());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Obx(() => ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (BuildContext context, int index) {
              final userData = controller.users[index];

              if (userData['email'] != controller.fba.currentUser!.email) {
                int hasNewMessage = 0;
                controller.cs
                    .newMessages(
                        controller.fba.currentUser!.uid, userData['userId'])
                    .then((value) => hasNewMessage = value);
                return MyUserTile(
                    hasNewMessage: hasNewMessage,
                    imageURL: userData['profilePicture'],
                    text: userData['username'],
                    onTap: () {
                      Get.to(() => NewNewChatPage(
                            imageURL: userData['profilePicture'],
                            userID: controller.fba.currentUser!.uid,
                            receiverUsername: userData['username'],
                            receiverID: userData['userId'],
                          ));
                    });
              } else {
                return Container();
              }
            },
          )),
    );
  }
}
