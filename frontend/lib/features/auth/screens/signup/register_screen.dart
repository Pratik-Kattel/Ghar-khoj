import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final FocusNode nameFocus = FocusNode();
  final TextEditingController nameController = TextEditingController();

  final FocusNode emailFocus = FocusNode();
  final TextEditingController emailController = TextEditingController();

  final FocusNode passwordFocus = FocusNode();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode confirmPasswordFocus = FocusNode();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void initState() {
    super.initState();

    nameFocus.addListener(() => setState(() {}));

    emailFocus.addListener(() => setState(() {}));

    passwordFocus.addListener(() => setState(() {}));

    confirmPasswordFocus.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryScaffold,
      appBar: AppBar(
        title: Text(
          "Register Now 👋",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 65.h,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Container(
                padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                margin: EdgeInsetsGeometry.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  gradient: LinearGradient(
                    colors: [Color(0xFFF3E8FF), Color(0xFFE9D5FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 3,
                      blurRadius: 35,
                      offset: Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 25),
                      child: Text(
                        "Register with name, email and password now to explore the app.",
                        style: TextStyle(fontSize: FontSizes.standardUP),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField.textField(
                      hintText: "Enter Name",
                      borderColor: nameFocus.hasFocus
                          ? AppColors.primary
                          : Colors.grey,
                      focus: nameFocus,
                      controller: nameController,
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                      contentPadding: 20,
                      iconPadding: 20,
                      Validator: (value) {},
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField.textField(
                      hintText: "Enter Email",
                      borderColor: emailFocus.hasFocus
                          ? AppColors.primary
                          : Colors.grey,
                      focus: emailFocus,
                      controller: emailController,
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                      contentPadding: 20,
                      iconPadding: 20,
                      Validator: (value) {},
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField.textField(
                      hintText: "Enter Password",
                      borderColor: passwordFocus.hasFocus
                          ? AppColors.primary
                          : Colors.grey,
                      focus: passwordFocus,
                      controller: passwordController,
                      prefixIcon: Icon(
                        Icons.lock_outline_sharp,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                      contentPadding: 20,
                      iconPadding: 20,
                      Validator: (value) {},
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField.textField(
                      hintText: "Confirm Password",
                      borderColor: confirmPasswordFocus.hasFocus
                          ? AppColors.primary
                          : Colors.grey,
                      focus: confirmPasswordFocus,
                      controller: confirmPasswordController,
                      prefixIcon: Icon(
                        Icons.lock_open_outlined,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                      contentPadding: 20,
                      iconPadding: 20,
                      Validator: (value) {},
                    ),
                    SizedBox(height: 45.h),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [Color(0xFFC084FC), Color(0xFF9333EA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: CustomButton.button(
                        texts: "Sign Up",
                        backgroundColor: Colors.transparent,
                        onPressed: () {},
                        context: context,
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 140.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: FontSizes.standardUP),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Sign in",
                            style: TextStyle(fontSize: FontSizes.standardUP),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
