import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_textfield.dart';

class ValidateOtpScreen extends StatefulWidget {
  const ValidateOtpScreen({super.key});

  @override
  ValidateOtpScreenState createState() => ValidateOtpScreenState();
}

class ValidateOtpScreenState extends State<ValidateOtpScreen> {
  final FocusNode otpFocus = FocusNode();
  final TextEditingController optController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    otpFocus.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryScaffold,
      body: SafeArea(
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
                controller: optController,
                prefixIcon: Icon(Icons.sms),
                contentPadding: 20,
                iconPadding: 20,
                Validator: (value) {},
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
      ),
    );
  }
}
