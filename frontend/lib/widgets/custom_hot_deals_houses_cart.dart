import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/api_endpoints.dart';
import '../features/HomeScreen/Model/hotdeals_model.dart';
import 'custom_house_details_screen.dart';

class CustomHotDealsHousesCart {
  static Widget customHotDeals({
    required List<HotDealModel> houses,
    required int ItemCount,
    int limit = 5,
  }) {
    if (houses.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Text(
            "No hot deals available",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ),
      );
    }

    final displayHouses = houses.length > limit
        ? houses.sublist(0, limit)
        : houses;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: displayHouses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _buildHotDealItem(displayHouses[index], context),
        );
      },
    );
  }

  static Widget customHotDealsVertical({
    required List<HotDealModel> houses,
  }) {
    if (houses.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Text(
            "No hot deals available",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: houses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _buildHotDealItem(houses[index], context),
        );
      },
    );
  }

  static Widget _buildHotDealItem(HotDealModel house, BuildContext context) {
    final imageUrl = house.imageUrl.isNotEmpty
        ? (house.imageUrl.startsWith("http")
        ? house.imageUrl
        : "${ApiEndpoints.imageBaseUrl}${house.imageUrl}")
        : null;

    final place = house.place.isNotEmpty ? house.place : "Unknown location";

    final priceDisplay = house.price == 0
        ? "N/A"
        : house.price % 1 == 0
        ? "\$${house.price.toInt()}/month"
        : "\$${house.price.toStringAsFixed(2)}/month";

    final title = house.title.isNotEmpty ? house.title : "No title";
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CustomHouseDetailScreen(
                houseId: house.houseId,
                title: house.title,
                imageUrl: house.imageUrl,
                place: house.place,
                price: house.price,
                latitude: house.latitude,
                longitude: house.longitude,
                description: house.description,
              ),
            ),
          );
        },
    child:  Row(
      children: [
        SizedBox(
          height: 75.h,
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: imageUrl != null
                  ? Image.network(
                imageUrl,
                width: 100.w,
                height: 75.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _fallbackImage(),
              )
                  : _fallbackImage(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
                  Text(
                    place,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Text(
                    priceDisplay,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color:Color(0xFFFFCDD2),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 5.w),
                        Icon(Icons.local_fire_department_rounded, color: Color(0xFFFFC107), size: 18),
                        SizedBox(width: 5.w),
                        Text(
                          "Hot",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(width: 7.w),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    )
    );
  }

  static Widget _fallbackImage() {
    return Container(
      width: 100,
      height: 75,
      color: Colors.grey[300],
      child: Icon(Icons.home, color: Colors.grey[600], size: 35),
    );
  }
}