import 'package:flutter/material.dart';
import 'package:frontend/features/Settings/Screen/profile_page.dart';
import 'package:frontend/features/WishList/screens/wishlist_screen.dart';
import '../Add_house/Screen/add_house_screen.dart';
import '../Home/Screen/HomeScreen.dart';
import '../Home/Screen/my_houses_screen.dart';
import '../My houses/Screens/my_rents_screen.dart';

class BottomNavigator extends StatefulWidget {
  final String role;
  const BottomNavigator({super.key, this.role = 'TENANT'});

  @override
  BottomNavigatorstate createState() => BottomNavigatorstate();
}

class BottomNavigatorstate extends State<BottomNavigator> {
  int _currentIndex = 0;

  List<Widget> get _tenantPages => [
    Homescreen(),
    WishlistScreen(),
    MyRentsScreen(),
    SettingsScreen(),
  ];

  List<Widget> get _landlordPages => [
    Homescreen(),
    UploadHouseScreen(),
    MyHousesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isLandlord = widget.role == 'LANDLORD';
    final pages = isLandlord ? _landlordPages : _tenantPages;

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: isLandlord
            ? const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_home), label: "Add House"),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_work), label: "My Houses"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ]
            : const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_work), label: "My Rents"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}