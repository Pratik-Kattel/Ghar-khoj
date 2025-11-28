import 'package:flutter/material.dart';
import 'package:frontend/themes/app_themes.dart';

class CustomSnackBar{
  static SnackBar buildSnackBar({
    IconData?icon,
    required String message,
    required BuildContext context,
    required Color bgColor,
    Color? iconColor,
    Color? messageColor
}){
  return SnackBar(
    content: Row(
      children: [
        Icon(icon,color: iconColor,),
        SizedBox(
          width:5,
        ),
        Expanded(child: Text(message,style: TextStyle(
          color: messageColor
        ),))
      ],
    ),
    backgroundColor: bgColor,
    behavior: SnackBarBehavior.fixed,
    shape: RoundedSuperellipseBorder(
      side: BorderSide(
        width: 0.1
      )
    ),
    duration: Duration(seconds: 4),
  );
}
}