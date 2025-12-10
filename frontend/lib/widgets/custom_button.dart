import 'package:flutter/material.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomButton{
 static Widget button({required texts,required VoidCallback? onPressed,required BuildContext context,required EdgeInsetsGeometry padding}){
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          backgroundColor: AppColors.primary,
          padding: padding
        ),
        onPressed: onPressed, child: Text(texts,style:TextStyle(
      fontSize: FontSizes.standardUP,
      color: Colors.white
    )));
  }
}