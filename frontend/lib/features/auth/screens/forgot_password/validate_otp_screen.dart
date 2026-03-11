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

class ValidateOtpScreen extends StatefulWidget {
  final String email;
  const ValidateOtpScreen({required this.email,super.key});

  @override
  ValidateOtpScreenState createState() => ValidateOtpScreenState();
}

class ValidateOtpScreenState extends State<ValidateOtpScreen> {
  final FocusNode otpFocus = FocusNode();
  final TextEditingController optController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isDialouge = false;

  @override
  void initState() {
    super.initState();
    otpFocus.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryScaffold,
      body: BlocConsumer<OTPValidationBloc, OTPValidationState>(
        listener: (context, state) {
          if (state.isSubmitting && !_isDialouge) {
            _isDialouge = true;
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => Center(child: CircularProgressIndicator()),
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
                bgColor: Colors.white,
                messageColor: Colors.red,
              ),
            );

            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                  message: "Validation successful",
                  context: context,
                  bgColor: Colors.white,
                  messageColor: Colors.green,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 15.w),
                    child: Text(
                      "Please enter the OTP that has been sent to your email address",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  CustomTextField.textField(
                    hintText: "Enter the otp here",
                    borderColor: otpFocus.hasFocus
                        ? AppColors.primary
                        : Colors.grey,
                    focus: otpFocus,
                    errorMessage: state.otpError,
                    controller: optController,
                    prefixIcon: Icon(Icons.sms),
                    contentPadding: 20,
                    iconPadding: 20,
                    Validator: (value) {
                      if(value.isEmpty && value==null){
                        return "Please enter OTP first";
                      }
                    },
                  ),
                  SizedBox(height: 30.h),
                  CustomButton.button(
                    texts: "Submit",
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        context.read<OTPValidationBloc>().add(
                          OTPChangedEvent(optController.text)
                        );
                        context.read<OTPValidationBloc>().add(
                          EmailChangedEvent(widget.email)
                        );

                        context.read<OTPValidationBloc>().add(
                          OTPSubmittedEvent()
                        );
                      }
                    },
                    context: context,
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 0.4.sw),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
