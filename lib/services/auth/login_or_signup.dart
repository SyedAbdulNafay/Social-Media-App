import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/auth_controller.dart';
import 'package:social_media_app/views/new_login_page.dart';

import '../../views/new_signup_page.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return controller.showLoginPage.value
            ? const NewLoginPage()
            : const NewSignupPage();
      },
    );
  }
}
