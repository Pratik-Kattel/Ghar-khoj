import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHouseNearbyCart {
  static Widget customNearbyCart({
    required List houses,
    required int ItemCount
}){
    return           Container(
      height: 103.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
      ),
      child:
      ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: ItemCount,
          itemBuilder: (context, index) {
            return Row(
              children: [
                SizedBox(
                  height: 75.h,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(
                        10.r,
                      ),
                      child: Image.asset(
                        houses[1],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      Text(
                        "Kuwait Villa",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                            size: 25,
                          ),
                          Text("Sundar Dulari, Nepal"),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          Text(
                            "\$320 /month",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 57.w,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFFFE5B4),
                                borderRadius: BorderRadius.circular(5.r)
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5.w,
                                ),
                                Icon(Icons.star, color: Color(0xFFFFC107)),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text("4.5",style: TextStyle(
                                  color: Colors.black
                                ),),
                                SizedBox(
                                  width: 7.w,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
            )
    );
  }
}