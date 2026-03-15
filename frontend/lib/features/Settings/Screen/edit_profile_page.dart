import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_textfield.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController username = TextEditingController();
    final FocusNode usernameFocus = FocusNode();
    final TextEditingController email = TextEditingController();
    final FocusNode emailFocus = FocusNode();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Center(
              child: Text(
                "Edit profile",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomTextField.textField(
              hintText: "Name",
              borderColor: Colors.grey,
              focus: usernameFocus,
              controller: username,
              prefixIcon: Icon(Icons.person,color: AppColors.primary,),
              contentPadding: 20,
              iconPadding: 20,
              Validator: (value) {},
              width: 2,
            ),
          ],
        ),
      ),
    );
  }
}
