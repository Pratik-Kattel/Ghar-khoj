import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
///This class represents the themes that will be used in the overall app

class AppColors{
  static const primary=Color(0xFF7F56D9);
  static const textPrimary=Colors.black;
  static const grey=Colors.grey;
  static const redColor=Colors.red;
  static const secondaryScaffold= Color(0xFFF3E8FF);
}

class FontSizes{
  static const small = 12.0;
  static const standard = 14.0;
  static const standardUP = 16.0;
  static const medium = 20.0;
  static const large = 28.0;
}

class AppThemes{
  static ThemeData get purpleTheme{
    return ThemeData(
      primaryColor:Color(0xFF7F56D9),
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
          titleMedium: GoogleFonts.poppins(
            fontSize: FontSizes.medium.sp,
            color: Colors.black,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: FontSizes.large.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500

          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: FontSizes.standardUP.sp,
            color: Colors.black,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: FontSizes.standard.sp,
            color: AppColors.grey,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: FontSizes.standardUP.sp,
            color: AppColors.grey,
          ),
      )
    );
}
}