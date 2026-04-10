import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/Admin%20Dashboard/Screen/admin_house_screen.dart';
import 'package:frontend/features/Settings/Screen/profile_page.dart';
import 'package:frontend/features/WishList/screens/wishlist_screen.dart';
import 'package:frontend/services/get_user_data.dart';
import '../Add_house/Screen/add_house_screen.dart';
import '../Admin Dashboard/Screen/admin_dashboard_screen.dart';
import '../Home/Bloc/home_screen/home_screen_bloc.dart';
import '../Home/Bloc/home_screen/home_screen_event.dart';
import '../Home/Screen/HomeScreen.dart';
import '../My houses/Screen/my_houses_screen.dart';
import '../My rents/Screens/my_rents_screen.dart';

class BottomNavigator extends StatefulWidget {
  final String role;
  const BottomNavigator({super.key, this.role = 'TENANT'});

  @override
  BottomNavigatorstate createState() => BottomNavigatorstate();
}

class BottomNavigatorstate extends State<BottomNavigator> {
  int _currentIndex = 0;
  String _role='TENANT';

  Future<void> _loadRole() async{
    final role=await GetUserDataRepo.getUserRole();
    setState(() {
      _role=role ?? widget.role;
    });
  }
  void initState(){
    super.initState();
    _role = widget.role;
    _loadRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeScreenBloc>().add(HomeStarted());
    });
  }
  List<Widget> get _tenantPages => [
    Homescreen(),
    WishlistScreen(),
    MyRentsScreen(),
    SettingsScreen(),
  ];

  List<Widget> get _landlordPages => [
    UploadHouseScreen(),
    MyHousesScreen(),
    SettingsScreen(),
  ];
  List<Widget> get _adminPages=>[
    AdminDashboardScreen(),
    AdminHousesScreen(),
    SettingsScreen(),

  ];
  @override
  @override
  Widget build(BuildContext context) {
    final isLandlord = _role == 'LANDLORD';
    final isAdmin = _role == 'ADMIN';

    final pages = isAdmin
        ? _adminPages
        : isLandlord
        ? _landlordPages
        : _tenantPages;

    final safeIndex = _currentIndex < pages.length ? _currentIndex : 0;

    return Scaffold(
      body: pages[safeIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: safeIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: isAdmin
            ? const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.house),label: "Manage Houses"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),

        ]
            : isLandlord
            ? const [
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