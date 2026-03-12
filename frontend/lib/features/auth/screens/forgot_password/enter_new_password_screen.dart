import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_textfield.dart';

class EnterNewPasswordScreen extends StatefulWidget {
  final String email;

  const EnterNewPasswordScreen({required this.email, super.key});

  @override
  EnterNewPasswordScreenState createState() => EnterNewPasswordScreenState();
}

class EnterNewPasswordScreenState extends State<EnterNewPasswordScreen> {
  final FocusNode passwordFocus = FocusNode();
  final FocusNode reEnterPasswordFocus = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reEnterPasswordController =
      TextEditingController();

  bool _isRePasswordVisible = false;
  bool _isPasswordVisible = false;

  void initState() {
    super.initState();
    passwordFocus.addListener(() => setState(() {}));
    reEnterPasswordFocus.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryScaffold,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Center(
              child: Text(
                "Enter the new password.",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(height: 30.h),
            CustomTextField.textField(
              obSecureText: !_isPasswordVisible,
              hintText: "Enter password here",
              borderColor: passwordFocus.hasFocus
                  ? AppColors.primary
                  : Colors.grey,
              focus: passwordFocus,
              controller: passwordController,
              prefixIcon: Icon(Icons.lock, color: AppColors.primary),
              contentPadding: 20,
              iconPadding: 20,
              suffixIcon: Padding(
                padding: EdgeInsetsGeometry.only(top: 10.h),
                child: IconButton(
                  color: AppColors.primary,
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: _isPasswordVisible
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
              ),
              Validator: (value) {
                if (value.isEmpty && value == null) {
                  return "Please enter the password first";
                }
              },
            ),
            SizedBox(height: 30.h),
            CustomTextField.textField(
              obSecureText: !_isRePasswordVisible,
              hintText: "Re-enter password here",
              borderColor: reEnterPasswordFocus.hasFocus
                  ? AppColors.primary
                  : Colors.grey,
              focus: reEnterPasswordFocus,
              controller: reEnterPasswordController,
              prefixIcon: Icon(Icons.lock_open, color: AppColors.primary),
              contentPadding: 20,
              iconPadding: 15,
              suffixIcon: Padding(
                padding: EdgeInsetsGeometry.only(top: 10.h),
                child: IconButton(
                  color: AppColors.primary,
                  onPressed: () {
                    setState(() {
                      _isRePasswordVisible = !_isRePasswordVisible;
                    });
                  },
                  icon: _isRePasswordVisible
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
              ),
              Validator: (value) {
                if (value.isEmpty && value == null) {
                  return "Please enter the password here also";
                }
              },
            ),
            SizedBox(height: 30.h),
            CustomButton.button(
              texts: "Submit",
              onPressed: () {},
              context: context,
              padding: EdgeInsetsGeometry.symmetric(horizontal: 0.4.sw),
            ),
          ],
        ),
      ),
    );
  }
}
