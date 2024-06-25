import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/services/auth/auth.dart';
import 'package:social_media_app/services/auth/login_or_signup.dart';
import 'package:social_media_app/firebase_options.dart';
import 'package:social_media_app/pages/home_page.dart';
import 'package:social_media_app/pages/profile_page.dart';
import 'package:social_media_app/pages/users_page.dart';
import 'package:social_media_app/theme/dartkmode.dart';
import 'package:social_media_app/theme/lightmode.dart';
import 'package:social_media_app/theme/theme_manager.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final themeManager = ThemeManager();
  runApp(ChangeNotifierProvider<ThemeManager>(
    create: (_) => themeManager,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const AuthPage(),
          theme: themeManager.isDarkMode ? darkTheme : lightTheme,
          routes: {
            '/login_or_signup_page': (context) => const LoginOrSignup(),
            '/home_page': (context) => const HomePage(),
            '/profile_page': (context) => const ProfilePage(),
            '/users_page': (context) => UsersPage(),
          },
        );
      },
    );
  }
}
