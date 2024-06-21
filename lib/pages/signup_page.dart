import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/my_button.dart';
import 'package:social_media_app/widgets/my_text_field.dart';

class SignUpPage extends StatefulWidget {
  final void Function()? onTap;
  SignUpPage({super.key, required this.onTap});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late FocusNode _focusNode;
  final _formKey = GlobalKey<FormState>();
  bool isSigningIn = false;

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      isSigningIn = true;
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailcontroller.text,
                password: _passwordcontroller.text);

        createUserDocument(userCredential);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.code)));
      }
      isSigningIn = false;
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': _usernamecontroller.text,
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
    if (_confirmPWcontroller.text != _passwordcontroller.text) {
      return "Passwords do not match";
    }
    return null;
  }

  //text controllers
  final TextEditingController _usernamecontroller = TextEditingController();

  final TextEditingController _emailcontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();

  final TextEditingController _confirmPWcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                      color: Theme.of(context).colorScheme.inversePrimary,
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

                    //username textfield
                    MyTextField(
                      focusNode: _focusNode,
                        hintText: "Username",
                        obscureText: false,
                        controller: _usernamecontroller),
                    const SizedBox(
                      height: 10,
                    ),

                    //email text field
                    MyTextField(
                      focusNode: _focusNode,
                        validator: emailValidator,
                        hintText: "Email",
                        obscureText: false,
                        controller: _emailcontroller),
                    const SizedBox(
                      height: 10,
                    ),

                    //password text field
                    MyTextField(
                      focusNode: _focusNode,
                        validator: passwordValidator,
                        hintText: "Password",
                        obscureText: true,
                        controller: _passwordcontroller),
                    const SizedBox(
                      height: 10,
                    ),

                    //confirm password text field
                    MyTextField(
                      focusNode: _focusNode,
                        validator: confirmPWValidator,
                        hintText: "Confirm Password",
                        obscureText: true,
                        controller: _confirmPWcontroller),
                    const SizedBox(
                      height: 25,
                    ),

                    //log in button
                    MyButton(
                      onTap: register,
                      child: isSigningIn
                          ? CircularProgressIndicator()
                          : Text(
                              "Log In",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
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
                            onTap: widget.onTap,
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
