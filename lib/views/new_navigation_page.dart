import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:social_media_app/controllers/navigation_controller.dart';

class NewNavigationPage extends StatelessWidget {
  const NewNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Container(
        color: Get.theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: GNav(
              selectedIndex: navigationController.selectedIndex,
              onTabChange: (value) {
                navigationController.changeIndex(value);
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              color: Get.isDarkMode ? Colors.grey : Colors.black,
              activeColor: Theme.of(context).colorScheme.inversePrimary,
              tabBackgroundColor: Theme.of(context).colorScheme.secondary,
              gap: 10,
              padding: const EdgeInsets.all(16),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.search,
                  text: "Discover",
                ),
                GButton(
                  icon: Icons.message,
                  text: "Messages",
                ),
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                )
              ]),
        ),
      ),
      body: Obx(
          () => navigationController.pages[navigationController.selectedIndex]),
    );
  }
}
