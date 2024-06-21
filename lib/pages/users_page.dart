import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/my_back_button.dart';
import 'package:social_media_app/widgets/my_users_box.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              );
            }
            if (snapshot.hasError) {
              showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                        content: Text("Something went wrong"),
                      ));
            }
            if (snapshot.data == null) {
              return const Text("NO DATA");
            }

            final users = snapshot.data!.docs;

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50, left: 25),
                  child: Row(
                    children: [
                      MyBackButton(),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];

                        return MyUsersBox(
                            username: user['username'], email: user['email']);
                      }),
                ),
              ],
            );
          }),
    );
  }
}
