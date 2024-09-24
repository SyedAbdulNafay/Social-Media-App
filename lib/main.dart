import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/services/auth/auth.dart';
import 'package:social_media_app/firebase_options.dart';
import 'package:social_media_app/services/theme/dartkmode.dart';
import 'package:social_media_app/services/theme/lightmode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
