import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_event.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_state.dart';
import 'package:frontend/features/auth/screens/forgot_password/validate_otp_screen.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/widgets/custom_snackbar.dart';
import 'package:frontend/widgets/custom_textfield.dart';
import 'package:frontend/widgets/custom_button.dart';

class ForgotPassword extends StatefulWidget {
  @override
  const ForgotPassword({super.key});

  @override
  ForgotPassword_State createState() => ForgotPassword_State();
}

class ForgotPassword_State extends State<ForgotPassword> {
  final emailFocus = FocusNode();
  final emailController = TextEditingController();
  bool _isdialouge = false;
  final formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    emailFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryScaffold,
      body: SafeArea(
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state.isSubmitting && !_isdialouge) {
              _isdialouge = true;
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }
            if (!state.isSubmitting && _isdialouge) {
              _isdialouge = false;
              Navigator.pop(context);
            }
            if (state.generalError != null && state.generalError!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                  message: state.generalError,
                  context: context,
                  bgColor: Colors.black,
                  messageColor: Colors.red,
                ),
              );
            }
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                  message: "Validation successful",
                  icon: Icons.verified_user,
                  iconColor: Colors.green,
                  context: context,
                  bgColor: Colors.white,
                  messageColor: Colors.green,
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ValidateOtpScreen(email: emailController.text),
                ),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
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
                    width: 2,
                    hintText: "Enter email here",
                    borderColor: emailFocus.hasFocus
                        ? AppColors.primary
                        : Colors.grey,
                    focus: emailFocus,
                    errorMessage: state.emailError,
                    controller: emailController,
                    prefixIcon: Icon(Icons.email),
                    contentPadding: 20,
                    iconPadding: 19,
                    Validator: (value) {
                      if (value.isEmpty && value == null) {
                        return "Please enter email address";
                      } else if (!value.contains('@gmail.com')) {
                        return "Please enter valid email address";
                      }
                      ;
                    },
                  ),
                  SizedBox(height: 40.h),
                  CustomButton.button(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 0.4.sw),
                    texts: "Submit",
                    context: context,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<ForgotPasswordBloc>().add(
                          EmailChanged(emailController.text.trim()),
                        );
                        context.read<ForgotPasswordBloc>().add(
                          EmailSubmitted(),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
