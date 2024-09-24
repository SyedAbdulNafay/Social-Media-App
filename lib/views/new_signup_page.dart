import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/auth_controller.dart';

import '../services/widgets/my_button.dart';
import '../services/widgets/my_text_field.dart';

class NewSignupPage extends StatelessWidget {
  const NewSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: authController.signupFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //logo
                    Icon(
                      Icons.person,
                      color: Get.isDarkMode
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Colors.black,
                      size: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    //name
                    const Text(
                      "M I N I M A L",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(
                      height: 50,
                    ),

                    MyTextField(
                        isReplying: false,
                        hintText: "Username",
                        obscureText: false,
                        controller: authController.usernameController),

                    //email text field
                    MyTextField(
                        isReplying: false,
                        validator: authController.emailValidator,
                        hintText: "Email",
                        obscureText: false,
                        controller: authController.emailController),

                    //password text field
                    MyTextField(
                        isReplying: false,
                        validator: authController.passwordValidator,
                        hintText: "Password",
                        obscureText: true,
                        controller: authController.passwordController),

                    //confirm password text field
                    MyTextField(
                        isReplying: false,
                        validator: authController.confirmPWValidator,
                        hintText: "Confirm Password",
                        obscureText: true,
                        controller: authController.confirmPWController),
                    const SizedBox(
                      height: 20,
                    ),
                    //log in button
                    MyButton(
                      onTap: authController.register,
                      child: authController.isSigningIn.value
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    //dont have accout, register here
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: authController.togglePages(),
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
