import 'package:flutter/material.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/widgets/custom_textfield.dart';
import 'package:frontend/widgets/custom_button.dart';

class ForgotPassword extends StatefulWidget {
  @override
  const ForgotPassword({super.key});

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailFocus = FocusNode();
  final emailController = TextEditingController();

  void initState() {
    super.initState();
    emailFocus.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryScaffold,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment(0, 1),
              child: Text(
                "Please enter your email address",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(height: 20.h),
            CustomTextField.textField(
              hintText: "Enter email here",
              borderColor: emailFocus.hasFocus
                  ? AppColors.primary
                  : Colors.grey,
              focus: emailFocus,
              controller: emailController,
              prefixIcon: Icon(Icons.email),
              contentPadding: 20,
              iconPadding: 19,
              Validator: (value) {},
            ),
            SizedBox(height: 40.h),
            CustomButton.button(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 0.4.sw),
              texts: "Submit",
              context: context,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
