import 'package:flutter/material.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:flutter/cupertino.dart';

class CustomButton{
 static Widget button({required texts,required VoidCallback? onPressed,required BuildContext context}){
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          padding: EdgeInsetsGeometry.symmetric(vertical: 15,horizontal: 150),
          backgroundColor: AppColors.primary
        ),
        onPressed: onPressed, child: Text(texts,style:TextStyle(
      fontSize: FontSizes.standardUP,
      color: Colors.white
    )));
  }
}