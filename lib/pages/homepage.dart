import 'package:flutter/material.dart';
import 'package:social_media_app/pages/feed_page.dart';
import 'package:social_media_app/pages/users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [const FeedPage(), UsersPage()],
      ),
    );
  }
}
