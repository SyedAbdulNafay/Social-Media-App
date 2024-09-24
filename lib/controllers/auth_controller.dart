import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isUserLoggedIn = false.obs;
  var showLoginPage = true.obs;
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmPWController = TextEditingController();
  var isLoggingIn = false.obs;
  var isSigningIn = false.obs;

  togglePages() {
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
    confirmPWController.clear();
    showLoginPage.value = !showLoginPage.value;
  }

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      isLoggingIn.value = true;
      try {
        final query = FirebaseFirestore.instance
            .collection("Users")
            .where("email", isEqualTo: emailController.text);
        final querysnapshot = await query.get();

        if (querysnapshot.docs.isEmpty) {
          Get.snackbar("Error", "This email is not valid");
          isLoggingIn.value = false;
          return;
        }

        await _auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong password') {
          Get.snackbar("Error", "Invalid email or password");
        } else {
          Get.snackbar("Error", "$e");
        }
      }
      isLoggingIn.value = false;
    }
  }

  Future<void> register() async {
    if (signupFormKey.currentState!.validate()) {
      isSigningIn.value = true;
      try {
        final usernameQuery = await FirebaseFirestore.instance
            .collection("Users")
            .where("username", isEqualTo: usernameController.text)
            .get();
        if (usernameQuery.docs.isNotEmpty) {
          Get.snackbar("Error", "Username is already in use");
          isSigningIn.value = false;
          return;
        }
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        createUserDocument(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          Get.snackbar("Error", "Email already in use");
        } else {
          Get.snackbar("Error", "$e");
        }
      }
      isSigningIn.value = false;
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({
        'userId': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'bio': 'Empty bio...',
        'profilePicture': 'not selected'
      });
    }
  }

  //validators
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty";
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return "Enter valid email";
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty";
    }
    if (value.length < 8) {
      return "Password must be longer than 8 characters";
    }
    return null;
  }

  String? confirmPWValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty";
    }
    if (value.length < 8) {
      return "Password must be longer than 8 characters";
    }
    if (confirmPWController.text != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        isUserLoggedIn.value = true;
      } else {
        isUserLoggedIn.value = false;
      }
    });
  }
}
