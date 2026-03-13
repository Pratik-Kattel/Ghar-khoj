import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/get_user_data.dart';
import 'package:frontend/themes/app_themes.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  HomescreenState createState() => HomescreenState();
}

class HomescreenState extends State<Homescreen> {
  late bool _isLoading = true;
  late String name;

  void fetchUsername() async {
    final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
    final getUserDataRepo = GetUserDataRepo(apiClient);
    final getUsername = GetUserName(getUserDataRepo: getUserDataRepo);
    var userName = await getUsername.getuserName();
    if (userName != null) {
      setState(() {
        _isLoading = false;
        name = userName;
      });
    }
  }

  void initState() {
    super.initState();
    fetchUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryScaffold,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsetsGeometry.only(left: 15),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      "Hello $name !",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
