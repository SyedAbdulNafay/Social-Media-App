import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/theme/theme_manager.dart';
import 'package:social_media_app/widgets/my_button.dart';
import 'package:social_media_app/widgets/my_text_field.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool isLoggingIn = false;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      isLoggingIn = true;
      try {
        final query = FirebaseFirestore.instance
            .collection("Users")
            .where("email", isEqualTo: _emailcontroller.text);
        final querySnapshot = await query.get();

        if (querySnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: const Text("This email is not valid")));
          isLoggingIn = false;
          return;
        }

        UserCredential? user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailcontroller.text,
                password: _passwordcontroller.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong password') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid email or password")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error: $e"),
          ));
        }
      }
      isLoggingIn = false;
    }
  }

  //validators
  Future<String?> emailValidator(String? value) async {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty";
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return "Enter valid email";
    }
    return null;
  }

  //text controllers
  final TextEditingController _emailcontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //logo
                    Icon(
                      Icons.person,
                      color: themeManager.isDarkMode
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

                    //email text field
                    MyTextField(
                      isReplying: false,
                        hintText: "Email",
                        obscureText: false,
                        controller: _emailcontroller),

                    //password text field
                    MyTextField(
                      isReplying: false,
                        hintText: "Password",
                        obscureText: true,
                        controller: _passwordcontroller),
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
                    ),

                    //log in button
                    MyButton(
                      onTap: login,
                      child: isLoggingIn
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Log In",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    //dont have accout, register here
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Dont have an account?"),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: widget.onTap,
                            child: Text(
                              "Sign In",
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
