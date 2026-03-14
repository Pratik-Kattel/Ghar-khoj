import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField {
  static Widget textField({
    required String hintText,
    required Color borderColor,
    required FocusNode focus,
    required TextEditingController controller,
    required Widget prefixIcon,
    String? errorMessage,
    bool obSecureText = false,
    required double contentPadding,
    required double iconPadding,
    required FormFieldValidator Validator,
    Widget? suffixIcon,
    required double width,
  }) {
    return Container(
      margin: EdgeInsetsGeometry.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: borderColor, width: width.w),
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        color: Colors.white,
      ),
      height: 65.h,
      width: double.infinity.w,
      child: TextFormField(
        obscureText: obSecureText,
        validator: Validator,
        focusNode: focus,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          errorText: errorMessage,
          contentPadding: EdgeInsetsGeometry.only(top: contentPadding.h,left: 20.w),
          hintStyle: TextStyle(
            fontSize: FontSizes.standardUP.sp,
            color: AppColors.grey,
          ),
          suffixIcon: suffixIcon,
          prefixIcon: Padding(
            padding: EdgeInsetsGeometry.only(right: 2.w, top: iconPadding.h),
            child: prefixIcon,
          ),
        ),
      ),
    );
  }
}
