import 'package:flutter/material.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton {
  static Widget button({
    required texts,
    required VoidCallback? onPressed,
    required BuildContext context,
    required EdgeInsetsGeometry padding,
    Color ? backgroundColor
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        backgroundColor: backgroundColor ?? AppColors.primary,
        padding: padding,
        elevation: backgroundColor==Colors.transparent? 0 :null
      ),
      onPressed: onPressed,
      child: Text(
        texts,
        style: TextStyle(fontSize: FontSizes.standardUP, color: Colors.white),
      ),
    );
  }
}
