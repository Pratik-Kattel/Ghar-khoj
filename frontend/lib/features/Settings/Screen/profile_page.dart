import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/services/secure_storage.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_list_tile.dart';
import '../../HomeScreen/Bloc/home_screen/home_screen_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late String name;
  late String email;

  void initState() {
    super.initState();
    final homeState = context.read<HomeScreenBloc>().state;
    setState(() {
      name = homeState.name ?? " ";
      email = homeState.email ?? " ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15.h),
            Center(
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 18.h),
            GestureDetector(
              onTap: () {},
              child: Center(
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundImage: AssetImage("Assets/Images/ronaldo.webp"),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 69.h,
                        left: 96.h,
                        child: CircleAvatar(
                          radius: 13.r,
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              name,
              style: TextStyle(fontSize: 17.sp, color: Colors.black),
            ),
            SizedBox(height: 5.h),
            Text(
              email,
              style: TextStyle(fontSize: 17.sp, color: Colors.black),
            ),
            SizedBox(height: 70.h),
            Divider(thickness: 1, color: Colors.grey),
            SizedBox(height: 10.h),
            CustomListTile.listTile(
              onTap: () {
                Navigator.pushNamed(context, '/editProfile');
              },
              icon: Icons.person,
              title: "Edit Profile",
              trailing: Icons.arrow_forward_ios_outlined,
            ),
            SizedBox(height: 15.h),
            CustomListTile.listTile(
              onTap: () {
                Navigator.pushNamed(context, '/aboutUs');
              },
              icon: Icons.info,
              title: "About",
              trailing: Icons.arrow_forward_ios_outlined,
            ),
            SizedBox(height: 15.h),
            CustomListTile.listTile(
              onTap: () {
                Navigator.pushNamed(context, '/contactUs');
              },
              icon: Icons.perm_contact_cal_outlined,
              title: "Contact Us",
              trailing: Icons.arrow_forward_ios_outlined,
            ),
            SizedBox(height: 15.h),
            CustomListTile.listTile(
              onTap: () {
                Navigator.pushNamed(context, '/addHouse');
              },
              icon: Icons.home,
              title: "Add home",
              trailing: Icons.arrow_forward_ios_outlined,
            ),
            SizedBox(height: 15.h),
            CustomListTile.listTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Center(
                        child: Text(
                          "Logout?",
                          style: TextStyle(color: AppColors.redColor),
                        ),
                      ),
                      content: Padding(
                        padding: EdgeInsetsGeometry.only(left: 10.w),
                        child:
                        Text("Sure want to logout?",style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black
                      ),),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, '/login');
                                await SecureStorage.deleteToken();
                              },
                              child: Text(
                                "Yes",
                                style: TextStyle(color: AppColors.redColor,fontSize: 16.sp),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "No",
                                style: TextStyle(color: AppColors.primary,fontSize: 16.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icons.logout,
              title: "Log out",
              bgColor: Colors.red,
              trailing: Icons.arrow_forward_ios_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
