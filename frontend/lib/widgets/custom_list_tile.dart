import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/app_themes.dart';

class CustomListTile {
  static Widget listTile({
    required IconData icon,
    required String title,
    required IconData trailing,
     Color? bgColor,
    required GestureTapCallback onTap,
}){
    return ListTile(
      splashColor: bgColor ?? AppColors.primary,
      onTap:  onTap,
      leading: Icon(icon, color: AppColors.primary),
      title: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: Text(title,style: TextStyle(
            fontSize: 18.sp
        ),),
      ),
      trailing: Icon(trailing),
    );
  }
}