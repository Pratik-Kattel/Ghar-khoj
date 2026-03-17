import 'package:flutter/material.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSnackBar{
  static SnackBar buildSnackBar({
    IconData?icon,
    required String? message,
    required BuildContext context,
    required Color bgColor,
    Color? iconColor,
    Color? messageColor,
    double ? fontSize
}){
  return SnackBar(
    content: Row(
      children: [
        Icon(icon,color: iconColor,),
        SizedBox(
          width:5.w,
        ),
        Expanded(child: Text(message!,style: TextStyle(
          color: messageColor,
          fontSize: fontSize
        ),))
      ],
    ),
    backgroundColor: bgColor,
    behavior: SnackBarBehavior.fixed,
    shape: RoundedSuperellipseBorder(
      side: BorderSide(
        width: 0.005.w
      )
    ),
    duration: Duration(seconds: 3),
  );
}
}