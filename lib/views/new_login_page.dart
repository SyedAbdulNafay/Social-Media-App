import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/auth_controller.dart';

import '../services/widgets/my_button.dart';
import '../services/widgets/my_text_field.dart';

class NewLoginPage extends StatelessWidget {
  const NewLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Get.theme.colorScheme.surface,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: authController.loginFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    color: Get.isDarkMode
                        ? Get.theme.colorScheme.inversePrimary
                        : Colors.black,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ), //name
                  const Text(
                    "M I N I M A L",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  //email text field
                  MyTextField(
                      validator: authController.emailValidator,
                      isReplying: false,
                      hintText: "Email",
                      obscureText: false,
                      controller: authController.emailController),
                  //password text field
                  MyTextField(
                      isReplying: false,
                      hintText: "Password",
                      obscureText: true,
                      controller: authController.passwordController),
                  const SizedBox(
                    height: 10,
                  ),
                  //forgot password
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text("Forgot password?")],
                  ),
                  const SizedBox(
                    height: 25,
                  ), //log in button
                  Obx(() => MyButton(
                        onTap: () => authController.login(),
                        child: authController.isLoggingIn.value
                            ? const CircularProgressIndicator()
                            : const Text(
                                "Log In",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Dont have an account?"),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: authController.togglePages(),
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.inversePrimary),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
