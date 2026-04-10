import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/get_user_data.dart';
import 'package:frontend/services/secure_storage.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_list_tile.dart';
import 'package:image_picker/image_picker.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../Home/Bloc/home_screen/home_screen_bloc.dart';
import '../../Landlord Request/Screen/become_landlord_screen.dart';
import '../../Settings/Bloc/profile_page/profile_page_bloc.dart';
import '../../Settings/Bloc/profile_page/profile_page_event.dart';
import '../../Settings/Bloc/profile_page/profile_page_state.dart';
import '../../Theme_switch/cubit/theme_switch_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final ImagePicker _picker = ImagePicker();
  String? email;
  String? name;
  String? role;

  @override
  void initState() {
    final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
    final getUserDataRepo = GetUserDataRepo(apiClient);
    super.initState();
    final homeState = context
        .read<HomeScreenBloc>()
        .state;
    context.read<ProfilePageBloc>().add(
      EmailChangedEvent(email: homeState.email ?? ""),
    );
    context.read<ProfilePageBloc>().add(
      NameChangedEvent(name: homeState.name ?? ""),
    );
    context.read<ProfilePageBloc>().add(FetchProfilePicEvent());
    _loadUserInfo();
    _fetchUserName(getUserDataRepo);
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

  Future<void> _loadUserInfo() async {
    role = await GetUserDataRepo.getUserRole();
    email = await GetUserDataRepo.getUserEmail();
    setState(() {
      role = role;
      email = email;
    });
  }

  Future<void> _fetchUserName(GetUserDataRepo getUserDataRepo) async {
    final getUsername = GetUserName(getUserDataRepo: getUserDataRepo);
    final fetchedName = await getUsername.getuserName();
    setState(() {
      name = fetchedName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
        SingleChildScrollView(
          child:
        BlocConsumer<ProfilePageBloc, ProfilePageState>(
          listener: (context, state) {
            if (state.generalError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                    message: state.generalError!,
                    bgColor: Colors.red,
                    context: context
                ),
              );
            }
            if (state.justUpdatedPic) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                    message: "Profile picture updated!",
                    bgColor: Colors.green,
                    context: context
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

                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundColor: Colors.grey,
                        backgroundImage: state.isUploadingPic
                            ? null
                            : state.profilePicFile != null
                            ? FileImage(state.profilePicFile!)
                            : state.profilePicUrl != null
                            ? NetworkImage(state.profilePicUrl!)
                            : null,
                        child:
                        state.profilePicFile == null &&
                            state.profilePicUrl == null
                            ? Text(
                          name != null && name!.isNotEmpty
                              ? name![0].toUpperCase()
                              : ".",
                          style: TextStyle(
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
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
                  name ?? "Loading...",
                  style: TextStyle(fontSize: 17.sp, color: Colors.black),
                ),
                SizedBox(height: 5.h),
                Text(
                  email ?? "Loading...",
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
                if (role == 'TENANT')
                  CustomListTile.listTile(icon: Icons.person_2_outlined,
                      title: "Want to become a landlord?",
                      trailing: Icons.arrow_forward_ios,
                      onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BecomeLandlordScreen()));
                      }),
                SizedBox(height: 15.h),
                CustomListTile.listTile(
                  icon: Icons.password,
                  title: "Change Password",
                  trailing: Icons.arrow_forward_ios,
                  onTap: () {
                    Navigator.pushNamed(context, '/forgotPassword');
                  },
                ),
                // SizedBox(
                //   height: 15.h,
                // ),
                // BlocBuilder<ThemeSwitchCubit, bool>(
                //   builder: (context, isDarkMode) {
                //     return SwitchListTile(
                //       title: Text('Dark Mode'),
                //       secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                //       value: isDarkMode,
                //       onChanged: (_) => context.read<ThemeSwitchCubit>().toggleTheme(),
                //     );
                //   },
                // ),
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
                                fontSize: 18.sp,
                                color: Colors.black,
                              ),
                            ),
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
                                    style: TextStyle(
                                      color: AppColors.redColor,
                                      fontSize: 16.sp,
                                    ),
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
                                      fontSize: 16.sp,
                                    ),
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
      )
    );
  }
}
