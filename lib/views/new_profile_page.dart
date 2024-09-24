import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/profile_controller.dart';

import '../services/widgets/my_list_tile.dart';
import '../services/widgets/my_text_box.dart';

class NewProfilePage extends StatelessWidget {
  const NewProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Get.theme.colorScheme.surface,
        body: Obx(
          () => profileController.user.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                  color: Get.theme.colorScheme.inversePrimary,
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          profileController.uploadTask != null
                              ? StreamBuilder(
                                  stream: profileController
                                      .uploadTask?.snapshotEvents,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      debugPrint("snapshot has data");
                                      final data = snapshot.data!;
                                      double progress = data.bytesTransferred /
                                          data.totalBytes;

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
                            profileController.user['profilePicture'] !=
                                    'not selected'
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundImage: NetworkImage(
                                        profileController
                                            .user['profilePicture']),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    child: Icon(
                                      Icons.person,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 64,
                                    ),
                                  ),
                            GestureDetector(
                              onTap: () async {
                                await profileController.selectImage();
                                await profileController.saveProfile();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Theme.of(context).colorScheme.surface),
                                child: const Icon(
                                  Icons.edit,
                                ),
                              ),
                            )
                          ]),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(profileController.user['username'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        profileController.user['email'],
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
                        content: profileController.user['username'],
                        onPressed: () =>
                            profileController.editField('username'),
                      ),
                      MyTextBox(
                        title: "Bio",
                        content: profileController.user['bio'],
                        onPressed: () => profileController.editField('bio'),
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
                      Obx(() => profileController.posts.isEmpty
                          ? const Center(
                              child: Text(
                                "No posts...",
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 300,
                              child: ListView.builder(
                                  itemCount: profileController.posts.length,
                                  itemBuilder: (context, index) {
                                    final post = profileController.posts[index];
                                    return MyListTile(
                                        title: post['UserEmail'],
                                        subtitle: post['message'],
                                        timestamp: post['timestamp'],
                                        postId: post.id,
                                        likes: List<String>.from(
                                            post['likes'] ?? []));
                                  }),
                            )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
