import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/auth_controller.dart';
import 'package:social_media_app/services/auth/login_or_signup.dart';
import 'package:social_media_app/views/new_navigation_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      body: Obx(() => authController.isUserLoggedIn.value
          ? const NewNavigationPage()
          : const LoginOrSignup()),
    );
  }
}
