import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcons {

  static Widget icons({
    required String pathname,
    required int height,
    required int width,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        pathname,
        height: height.h,
        width: width.w,
      ),
    );
  }
}