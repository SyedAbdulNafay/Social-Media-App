import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/pages/discover_page.dart';
import 'package:social_media_app/pages/homepage.dart';
import 'package:social_media_app/pages/profile_page.dart';
import 'package:social_media_app/theme/theme_manager.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  List<Widget> pages = const [HomePage(), DiscoverPage(), ProfilePage()];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: GNav(
              selectedIndex: _selectedIndex,
              onTabChange: (value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              color: themeManager.isDarkMode ? Colors.grey : Colors.black,
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
                  icon: Icons.person,
                  text: "Profile",
                )
              ]),
        ),
      ),
      body: pages[_selectedIndex],
    );
  }
}
