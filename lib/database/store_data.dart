import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StoreData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> saveData({required Uint8List file, required String userID}) async {
    String resp = "some error happened";
    try {
      String imageURL = await uploadImageToStorage('profileImage', file);
      await _firestore.collection("Users").doc(userID).update({
        'profilePicture': imageURL
      });
      resp = 'success';
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }
}
