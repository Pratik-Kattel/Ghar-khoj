import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_event.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_snackbar.dart';
import 'package:frontend/widgets/custom_textfield.dart';

import '../../bloc/forgot_password/forgot_password_state.dart';

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

  bool _isDialouge = false;

  final formKey = GlobalKey<FormState>();

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
        child: BlocConsumer<PasswordChangeBloc, PasswordChangeState>(
          listener: (context, state) {
            if (state.isSubmitting && !_isDialouge) {
              _isDialouge = true;
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }
            if (!state.isSubmitting && _isDialouge) {
              _isDialouge = false;
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
                  message: "Password changed successfully",
                  context: context,
                  bgColor: Colors.white,
                  messageColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, PasswordChangeState state) {
            return Form(
              key: formKey,
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
                    errorMessage: state.passwordError,
                    hintText: "Enter password here",
                    borderColor: state.passwordError != null
                        ? AppColors.redColor
                        : (passwordFocus.hasFocus
                              ? AppColors.primary
                              : Colors.grey),
                    focus: passwordFocus,
                    controller: passwordController,
                    prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                    contentPadding: 20,
                    iconPadding: 15,
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
                    errorMessage: state.confirmPasswordError,
                    hintText: "Re-enter password here",
                    borderColor: state.confirmPasswordError != null
                        ? AppColors.redColor
                        : (reEnterPasswordFocus.hasFocus
                              ? AppColors.primary
                              : Colors.grey),
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
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<PasswordChangeBloc>().add(
                          PasswordChangedEvent(
                            password: passwordController.text.trim(),
                          ),
                        );
                        context.read<PasswordChangeBloc>().add(
                          ConfirmPasswordChangedEvent(
                            confirmPassword: reEnterPasswordController.text
                                .trim(),
                          ),
                        );
                        context.read<PasswordChangeBloc>().add(
                          ForgotPasswordEmailChanged(email: widget.email),
                        );
                        context.read<PasswordChangeBloc>().add(
                          PasswordSubmittedEvent(),
                        );
                      }
                    },
                    context: context,
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 0.4.sw),
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
