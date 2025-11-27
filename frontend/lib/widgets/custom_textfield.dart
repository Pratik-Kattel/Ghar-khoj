import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/themes/app_themes.dart';

class CustomTextField {
  static Widget textField({required String hintText,
    required Color borderColor,
    required FocusNode focus,
    required TextEditingController controller,
    required Widget iconData,
     String? errorMessage,
    bool obSecureText=false,
    required double containerMargin,
    required double contentPadding,
    required double iconPadding,
    required FormFieldValidator Validator,
    Widget? suffixIcon
  }) {
    return Container(
      margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      height: 65,
      width: double.infinity,
      child: TextFormField(
        obscureText: obSecureText,
        validator: Validator,
        focusNode: focus,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          errorText: errorMessage,
          contentPadding: EdgeInsetsGeometry.only(top: contentPadding,),
          hintStyle: TextStyle(
            fontSize: FontSizes.standardUP,
            color: AppColors.grey,
          ),
          suffixIcon: suffixIcon,
          prefixIcon: Padding(
            padding: EdgeInsetsGeometry.only(right:2,top: iconPadding),
            child: iconData,
          ),
        ),
      ),
    );
  }
}

