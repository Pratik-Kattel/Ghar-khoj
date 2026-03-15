import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/themes/app_themes.dart';

class ContactUsInfoScreen extends StatelessWidget {
  const ContactUsInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Contact Us"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo / title
              Icon(
                Icons.home_filled,
                size: 60.sp,
                color: AppColors.primary,
              ),
              SizedBox(height: 15.h),
              Text(
                "Ghar Khoj",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 40.h),

              // Phone
              contactRow(Icons.phone, "9827388429"),
              SizedBox(height: 20.h),

              // Email
              contactRow(Icons.email_outlined, "gharkhojrental@gmail.com"),
              SizedBox(height: 20.h),

              // Instagram
              contactRow(Icons.camera_alt_outlined, "@gharKhoj"),
              SizedBox(height: 20.h),

              // Location
              contactRow(Icons.location_on_outlined, "Sundar Dulari, Nepal"),
              SizedBox(height: 50.h),

              Spacer(),

              // Footer
              Text(
                "© 2026 Ghar Khoj®. All rights reserved.",
                style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contactRow(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 25.sp),
          SizedBox(width: 15.w),
          Text(
            text,
            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}