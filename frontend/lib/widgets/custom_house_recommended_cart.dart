import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/app_themes.dart';

class CustomHouseCart {

  static Widget houseCart({
    required int ItemCount,
    required List ImagePath,
    required String houseName,
    required String location,
    required String price,

  }) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: ItemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsetsGeometry.only(
              left: 10.w,
              right: 10.w,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(
                    12.r,
                  ),
                  child: Image.asset(ImagePath[index]),
                ),
                Positioned(
                  bottom: 45.h,
                  left: 22.w,
                  child: Text(
                   houseName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.h,
                  left: 8.w,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 15.w,
                  top: 12.h,
                  child: Container(
                    height: 25.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5.r,
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(
                        left: 10.w,
                        right: 10.w,
                      ),
                      child: Row(
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("/month"),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.h,
                  right: 18.w,
                  child: CircleAvatar(
                    radius: 15.r,
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Text(
                        "❤️",
                        style: TextStyle(fontSize: 17.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}