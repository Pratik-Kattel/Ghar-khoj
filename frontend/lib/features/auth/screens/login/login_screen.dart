import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/widgets/custom_snackbar.dart';
import '../../../Bottom_Navigator/Bottom_Navigator.dart';
import '../../bloc/login/login_state.dart';
import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfield.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  bool _isDialogOpen = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome Back 👋"),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 75.h,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: AppColors.secondaryScaffold,
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isSubmitting && !_isDialogOpen) {
              _isDialogOpen = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }

            if (!state.isSubmitting && _isDialogOpen) {
              _isDialogOpen = false;
              Navigator.pop(context);
            }

            if (state.generalError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                  message: state.generalError,
                  context: context,
                  bgColor: Colors.white,
                  messageColor: Colors.red,
                ),
              );
            }

            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                  message: "Login successful",
                  context: context,
                  bgColor: Colors.black,
                  messageColor: Colors.green,
                  icon: Icons.verified,
                  iconColor: Colors.green,
                ),
              );
              Navigator.pushReplacement(context,  MaterialPageRoute(
                builder: (_) => BottomNavigator(role: state.role ?? 'TENANT'),
              ),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 0.002.sh),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Text(
                        "Sign in with your email and password to continue",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(height: 35.h),

                    // Email field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: CustomTextField.textField(
                        width: 2,
                        contentPadding: 20,
                        iconPadding: 17,
                        hintText: "Enter Email",
                        borderColor: emailFocus.hasFocus
                            ? AppColors.primary
                            : (state.emailError != null
                                  ? AppColors.redColor
                                  : AppColors.grey),
                        focus: emailFocus,
                        controller: emailController,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.primary,
                          size: 25.sp,
                        ),
                        errorMessage: state.emailError,
                        Validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email should not be empty";
                          } else if (!value.endsWith('@gmail.com')) {
                            return "Please enter a valid email address";
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Password field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: CustomTextField.textField(
                        width: 2,
                        iconPadding: 10,
                        contentPadding: 20,
                        hintText: "Enter Password",
                        borderColor: passwordFocus.hasFocus
                            ? AppColors.primary
                            : (state.passwordError != null
                                  ? AppColors.redColor
                                  : AppColors.grey),
                        focus: passwordFocus,
                        controller: passwordController,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: AppColors.primary,
                          size: 25.sp,
                        ),
                        errorMessage: state.passwordError,
                        suffixIcon: Padding(
                          padding: EdgeInsetsGeometry.only(top: 8.h),
                          child: IconButton(
                            color: AppColors.primary,
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            icon: isPasswordVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                        ),
                        obSecureText: !isPasswordVisible,
                        Validator: (value) {
                          if (value.isEmpty || value == null) {
                            return "Password cannot be empty";
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 0.003.sh),
                    Align(
                      alignment: Alignment(0.8,0),
                      child:
                      TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgotPassword');
                      },
                      child: Text("Forgot password?",style: TextStyle(fontSize: 17),),
                    ),
                    ),
                    CustomButton.button(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 0.4.sw),
                      texts: "Login",
                      context: context,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(
                            EmailChanged(emailController.text),
                          );
                          context.read<LoginBloc>().add(
                            PasswordChanged(passwordController.text),
                          );
                          context.read<LoginBloc>().add(LoginSubmitted());
                        }
                      },
                    ),

                    SizedBox(height: 30.h),

                    // Signup Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ",style: Theme.of(context).textTheme.bodyLarge,),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              "/register",
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.35.sh),
                    Text(
                      "© 2025 Ghar Khoj®. All rights reserved.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
