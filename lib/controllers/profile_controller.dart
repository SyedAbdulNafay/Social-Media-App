import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/models/database/posts_firestore.dart';

import '../services/widgets/my_text_field.dart';

class ProfileController extends GetxController {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirestoreDatabase firestoreDatabase = FirestoreDatabase();
  final FirebaseAuth fba = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  XFile? image;
  UploadTask? uploadTask;

  var user = {}.obs;
  var posts = [].obs;
  var isLoading = false.obs;

  Future<void> getUser() async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection("Users");
      final userDoc = await usersCollection.doc(fba.currentUser!.uid).get();
      user.value = userDoc.data() as Map<String, dynamic>;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data");
    }
  }

  Future<void> getUserPosts() async {
    try {
      final postsStream = firestoreDatabase.getUserPostsStream();
      postsStream.listen((postsSnapshot) {
        posts.value = postsSnapshot.docs;
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user posts");
    }
  }

  Future<void> selectImage() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picture != null) {
      uploadTask = storage
          .ref()
          .child("images/${picture.name}")
          .putFile(File(picture.path));
    }
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    try {
      final snapshot = await uploadTask!.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(fba.currentUser!.uid)
          .update({'profilePicture': downloadUrl});
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", "Failed to save profile picture");
      isLoading.value = false;
    }
  }

  Future<void> editField(String field) async {
    String newString = "";
    await Get.dialog(
        AlertDialog(
          title: Text(
            "Edit $field",
          ),
          content: MyTextField(
            onChanged: (value) {
              newString = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            TextButton(
                onPressed: () {
                  if (newString.trim().isNotEmpty) {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(fba.currentUser!.uid)
                        .update({field: newString});
                  }
                  Get.back();
                },
                child: const Text("Save"))
          ],
        ),
        barrierDismissible: false);
    try {
      if (newString.trim().isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(fba.currentUser!.uid)
            .update({field: newString});
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to edit $field");
    }
  }

  @override
  void onInit() {
    super.onInit();
    getUser();
    getUserPosts();
  }
}
