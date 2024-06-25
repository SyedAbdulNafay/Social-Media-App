import 'package:flutter/material.dart';
import 'package:social_media_app/pages/login_page.dart';
import 'package:social_media_app/pages/signup_page.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return SignUpPage(onTap: togglePages);
    }
  }
}