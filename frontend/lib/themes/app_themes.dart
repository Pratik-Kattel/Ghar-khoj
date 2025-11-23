import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///This class represents the themes that will be used in the overall app

class AppColors{
  static const primary=Color(0xFF7F56D9);
  static const textPrimary=Colors.black;
  static const subText=Colors.grey;
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
            fontSize: FontSizes.medium,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: FontSizes.large,
            color: Colors.white,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: FontSizes.standardUP,
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: FontSizes.standard,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: FontSizes.standardUP,
            color: Colors.white,
          ),
      )
    );
}
}