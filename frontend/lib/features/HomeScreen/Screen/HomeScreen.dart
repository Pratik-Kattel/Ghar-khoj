import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/features/HomeScreen/Bloc/home_screen_bloc.dart';
import 'package:frontend/features/HomeScreen/Bloc/home_screen_event.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/get_user_data.dart';
import 'package:frontend/themes/app_themes.dart';

import '../Bloc/home_screen_state.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  HomescreenState createState() => HomescreenState();
}

class HomescreenState extends State<Homescreen> {
  // late bool _isLoading = true;
  // late String name;
  //
  // void fetchUsername() async {
  //   final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
  //   final getUserDataRepo = GetUserDataRepo(apiClient);
  //   final getUsername = GetUserName(getUserDataRepo: getUserDataRepo);
  //   var userName = await getUsername.getuserName();
  //   if (userName != null) {
  //     setState(() {
  //       _isLoading = false;
  //       name = userName;
  //     });
  //   }
  // }

  void initState() {
    super.initState();
    context.read<HomeScreenBloc>().add(HomeStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryScaffold,
      body: SafeArea(
        child: BlocConsumer<HomeScreenBloc, HomeScreenState>(
          listener: (context, state) {
          },
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(left: 15.w),
                      child: state.isLoading
                          ? Text("Loading...")
                          : Text(
                              "Hello ${state.name}!",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.primary),
                        Padding(
                          padding: EdgeInsetsGeometry.only(right: 10.w),
                          child: Text(
                            state.place??"Loading..",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
