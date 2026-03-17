import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_house_details_screen.dart';
import '../features/Recommendation/Model/recommendation_model.dart';

class CustomHouseCart {
  static Widget houseCart({
    required List<RecommendedModel> houses,
    int limit = 5,
  }) {
    if (houses.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Text(
            "No recommended houses found",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ),
      );
    }

    final displayHouses =
    houses.length > limit ? houses.sublist(0, limit) : houses;

    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: displayHouses.length,
        itemBuilder: (context, index) {
          final house = displayHouses[index];

          final imageUrl = house.imageUrl.isNotEmpty
              ? (house.imageUrl.startsWith("http")
              ? house.imageUrl
              : "${ApiEndpoints.imageBaseUrl}${house.imageUrl}")
              : null;

          final priceDisplay =
              "\$${house.price % 1 == 0 ? house.price.toInt() : house.price.toStringAsFixed(2)}";

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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: imageUrl != null
                        ? Image.network(
                      imageUrl,
                      width: 220.w,
                      height: 200.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _fallbackImage(),
                    )
                        : _fallbackImage(),
                  ),
                  Positioned(
                    bottom: 45.h,
                    left: 22.w,
                    child: Text(
                      house.title.isNotEmpty ? house.title : "No title",
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
                        Icon(Icons.location_on_outlined, color: Colors.white),
                        Text(
                          house.place.isNotEmpty ? house.place : "Unknown",
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
                        borderRadius: BorderRadius.circular(5.r),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: [
                            Text(
                              priceDisplay,
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
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFE5B4),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star,
                              color: Color(0xFFFFC107), size: 14),
                          SizedBox(width: 3.w),
                          Text(
                            house.averageRating == 0.0
                                ? "N/A"
                                : house.averageRating.toStringAsFixed(1),
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _fallbackImage() {
    return Container(
      width: 220,
      height: 200,
      color: Colors.grey[300],
      child: Icon(Icons.home, color: Colors.grey[600], size: 60),
    );
  }
}