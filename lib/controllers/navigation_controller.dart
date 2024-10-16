import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/views/new_feed_page.dart';
import 'package:social_media_app/views/new_profile_page.dart';
import 'package:social_media_app/views/new_users_page.dart';
import 'package:social_media_app/views/profile_page.dart';

class NavigationController extends GetxController {
  final _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  void changeIndex(int index) {
    _selectedIndex.value = index;
  }

  List<Widget> pages = [
    const NewFeedPage(),
    const NewProfilePage(),
    const NewUsersPage(),
    const ProfilePage(),
  ];
}
