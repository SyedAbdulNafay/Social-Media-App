import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/my_button.dart';
import 'package:social_media_app/widgets/my_text_field.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FocusNode _focusNode;
  final _formKey = GlobalKey<FormState>();

  bool isLoggingIn = false;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      isLoggingIn = true;
      try {
        UserCredential? user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailcontroller.text,
                password: _passwordcontroller.text);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.code)));
      }
      isLoggingIn = false;
    }
  }

  //text controllers
  final TextEditingController _emailcontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();

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

                    //email text field
                    MyTextField(
                        focusNode: _focusNode,
                        hintText: "Email",
                        obscureText: false,
                        controller: _emailcontroller),
                    const SizedBox(
                      height: 10,
                    ),

                    //password text field
                    MyTextField(
                        focusNode: _focusNode,
                        hintText: "Password",
                        obscureText: true,
                        controller: _passwordcontroller),
                    const SizedBox(
                      height: 10,
                    ),

                    //forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot password?",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    //log in button
                    MyButton(
                      onTap: login,
                      child: isLoggingIn
                          ? const CircularProgressIndicator()
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
