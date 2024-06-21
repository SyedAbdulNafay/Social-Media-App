import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/my_back_button.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.inversePrimary),
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              Map<String, dynamic>? user = snapshot.data!.data();
      
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 25),
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
                      Text(user!['username'],
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
