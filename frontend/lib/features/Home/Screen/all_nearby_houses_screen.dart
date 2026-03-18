import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/custom_house_nearby_cart.dart';
import '../Model/nearby_house_model.dart';

class AllNearbyHousesScreen extends StatelessWidget {
  final List<NearbyHouseModel> houses;

  const AllNearbyHousesScreen({super.key, required this.houses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nearby Houses",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: houses.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 10.h),
            Text(
              "No nearby houses found",
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.w, bottom: 10.h),
              child: Text(
                "${houses.length} houses found nearby",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ),
            CustomHouseNearbyCart.customNearbyCartVertical(
              houses: houses,
            ),
          ],
        ),
      ),
    );
  }
}