import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/services/secure_storage.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_list_tile.dart';
import 'package:image_picker/image_picker.dart';
import '../../Home/Bloc/home_screen/home_screen_bloc.dart';
import '../../Settings/Bloc/profile_page/profile_page_bloc.dart';
import '../../Settings/Bloc/profile_page/profile_page_event.dart';
import '../../Settings/Bloc/profile_page/profile_page_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final homeState = context.read<HomeScreenBloc>().state;
    context.read<ProfilePageBloc>().add(
      EmailChangedEvent(email: homeState.email ?? ""),
    );
    context.read<ProfilePageBloc>().add(
      NameChangedEvent(name: homeState.name ?? ""),
    );
    context.read<ProfilePageBloc>().add(FetchProfilePicEvent());
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<ProfilePageBloc>().add(
        ProfilePicChangedEvent(image: File(pickedFile.path)),
      );
      context.read<ProfilePageBloc>().add(ProfilePicSubmittedEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfilePageBloc, ProfilePageState>(
          listener: (context, state) {
            if (state.generalError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.generalError!),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (!state.isUploadingPic && state.profilePicUrl != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Profile picture updated!"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
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

                // ── Profile Picture ──
                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: state.isUploadingPic
                            ? null
                            : state.profilePicFile != null
                            ? FileImage(state.profilePicFile!)
                        as ImageProvider
                            : state.profilePicUrl != null
                            ? NetworkImage(state.profilePicUrl!)
                        as ImageProvider
                            : const AssetImage(
                            "Assets/Images/ronaldo.webp")
                        as ImageProvider,
                        child: state.isUploadingPic
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        top: 85.h,
                        left: 85.w,
                        child: CircleAvatar(
                          radius: 13.r,
                          backgroundColor: AppColors.primary,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  state.name.trim().isEmpty ? " " : state.name,
                  style: TextStyle(fontSize: 17.sp, color: Colors.black),
                ),
                SizedBox(height: 5.h),
                Text(
                  state.email.trim().isEmpty ? " " : state.email,
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
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              "Sure want to logout?",
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.black),
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pushNamed(context, '/login');
                                    await SecureStorage.deleteToken();
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                        color: AppColors.redColor,
                                        fontSize: 16.sp),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16.sp),
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
            );
          },
        ),
      ),
    );
  }
}