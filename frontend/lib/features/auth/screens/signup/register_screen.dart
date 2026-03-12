import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/features/auth/bloc/signup/signup_bloc.dart';
import 'package:frontend/features/auth/bloc/signup/signup_event.dart';
import 'package:frontend/features/auth/bloc/signup/signup_state.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_snackbar.dart';
import 'package:frontend/widgets/custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  bool _isDialougeOpen = false;
  bool _isPasswordVisible = false;
  bool _isRePasswordVisible=false;
  final formKey = GlobalKey<FormState>();

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
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 65.h,
      ),
      body: SafeArea(
        child: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (!state.isSubmitting && _isDialougeOpen) {
              _isDialougeOpen = false;
              Navigator.pop(context);
            }
            print("From UI:${state.generalError}");

            if (state.generalError != null && state.generalError!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                  message: state.generalError!,
                  context: context,
                  bgColor: Colors.white,
                  messageColor: AppColors.redColor,
                  fontSize: FontSizes.medium,
                ),
              );
            }
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                  message: "Registration successful, Please login to continue",
                  context: context,
                  bgColor: Colors.white,
                  messageColor: Colors.green,
                  icon: Icons.verified_user_outlined,
                  iconColor: Colors.green,
                ),
              );
              Navigator.pushNamed(context, '/login');
            }
            if (state.isSubmitting && !_isDialougeOpen) {
              _isDialougeOpen = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }
          },
          builder: (BuildContext context, SignupState state) {
            return Form(
              key: formKey,
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
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 25,
                            ),
                            child: Text(
                              "Register with name, email and password now to explore the app.",
                              style: TextStyle(fontSize: FontSizes.standardUP),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField.textField(
                            hintText: "Enter Name",
                            errorMessage: state.nameError,
                            borderColor: state.nameError != null
                                ? AppColors.redColor
                                : (nameFocus.hasFocus
                                      ? AppColors.primary
                                      : Colors.grey),
                            focus: nameFocus,
                            controller: nameController,
                            prefixIcon: Icon(
                              Icons.person,
                              color: AppColors.primary,
                              size: 25.sp,
                            ),
                            contentPadding: 20,
                            iconPadding: 20,
                            Validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter name";
                              }
                            },
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField.textField(
                            hintText: "Enter Email",
                            errorMessage: state.emailError,
                            borderColor: state.emailError != null
                                ? AppColors.redColor
                                : (emailFocus.hasFocus
                                      ? AppColors.primary
                                      : Colors.grey),
                            focus: emailFocus,
                            controller: emailController,
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppColors.primary,
                              size: 25.sp,
                            ),
                            contentPadding: 20,
                            iconPadding: 20,
                            Validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter email";
                              }
                              if (!value.endsWith('@gmail.com')) {
                                return "Please enter valid email address";
                              }
                            },
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField.textField(
                            obSecureText: !_isPasswordVisible,
                            hintText: "Enter Password",
                            errorMessage: state.passwordError,
                            borderColor: state.passwordError != null
                                ? AppColors.redColor
                                : (passwordFocus.hasFocus
                                      ? AppColors.primary
                                      : Colors.grey),
                            focus: passwordFocus,
                            controller: passwordController,
                            prefixIcon: Icon(
                              Icons.lock_outline_sharp,
                              color: AppColors.primary,
                              size: 25.sp,
                            ),
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
                            contentPadding: 20,
                            iconPadding: 20,
                            Validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter password";
                              }
                            },
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField.textField(
                            obSecureText: !_isRePasswordVisible,
                            hintText: "Confirm Password",
                            errorMessage: state.confirmError,
                            borderColor: state.confirmError != null
                                ? AppColors.redColor
                                : (confirmPasswordFocus.hasFocus
                                      ? AppColors.primary
                                      : Colors.grey),
                            focus: confirmPasswordFocus,
                            controller: confirmPasswordController,
                            prefixIcon: Icon(
                              Icons.lock_open_outlined,
                              color: AppColors.primary,
                              size: 25.sp,
                            ),
                            contentPadding: 20,
                            iconPadding: 20,
                            suffixIcon: Padding(
                              padding: EdgeInsetsGeometry.only(top: 10.h),
                              child: IconButton(
                                  color: AppColors.primary,
                                  onPressed: () {
                                setState(() {
                                  _isRePasswordVisible=!_isRePasswordVisible;
                                });
                              }, icon: _isRePasswordVisible?Icon(Icons.visibility):
                              Icon(Icons.visibility_off)
                              ),
                            ),
                            Validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please re-enter password here";
                              }
                            },
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
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<SignupBloc>().add(
                                    NameChanged(name: nameController.text),
                                  );
                                  context.read<SignupBloc>().add(
                                    EmailChanged(email: emailController.text),
                                  );
                                  context.read<SignupBloc>().add(
                                    PasswordChanged(
                                      password: passwordController.text,
                                    ),
                                  );
                                  context.read<SignupBloc>().add(
                                    PasswordConfirm(
                                      confirmPassword:
                                          confirmPasswordController.text,
                                    ),
                                  );
                                  context.read<SignupBloc>().add(
                                    SignupSubmitted(),
                                  );
                                }
                              },
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
                                style: TextStyle(
                                  fontSize: FontSizes.standardUP,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(
                                    fontSize: FontSizes.standardUP,
                                  ),
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
            );
          },
        ),
      ),
    );
  }
}
