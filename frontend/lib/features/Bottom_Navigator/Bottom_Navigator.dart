import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/HomeScreen/Screen/HomeScreen.dart';
import 'package:frontend/features/Settings/Screen/profile_page.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  BottomNavigatorstate createState() => BottomNavigatorstate();
}

class BottomNavigatorstate extends State<BottomNavigator> {
  int _currentIndex = 0;
  List<Widget> _pages = [Homescreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
