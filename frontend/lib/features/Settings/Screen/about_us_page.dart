import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/themes/app_themes.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryScaffold,
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo or image
              Center(
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundImage: AssetImage("Assets/Images/findHouse.jpg"),
                )
              ),
              SizedBox(height: 20.h),

              // App Name
              Center(
                child: Text(
                  "Ghar Khoj",
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              Center(
                child: Text(
                  "Find Your Dream Home",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.grey,
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Our Mission
              Text(
                "Our Mission",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "At Ghar Khoj, our mission is to make finding the perfect home easy, fast, and reliable. "
                    "We connect users with trusted property listings and provide seamless solutions for renting, buying, and selling real estate.",
                style: TextStyle(fontSize: 16.sp, color: AppColors.grey),
              ),
              SizedBox(height: 20.h),

              // Our Vision
              Text(
                "Our Vision",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "To be the most user-friendly real estate platform in Nepal, enabling everyone to find their dream home with confidence.",
                style: TextStyle(fontSize: 16.sp, color: AppColors.grey),
              ),

              SizedBox(height: 30.h),

              // Footer
              Center(
                child: Text(
                  "© 2026 Ghar Khoj®. All rights reserved.",
                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}