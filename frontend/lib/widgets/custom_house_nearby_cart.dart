import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import '../features/HomeScreen/Model/nearby_house_model.dart';

class CustomHouseNearbyCart {
  static final String _baseImageUrl = ApiEndpoints.imageBaseUrl;

  static Widget customNearbyCart({
    required List<NearbyHouseModel> houses,
    required int ItemCount,
  }) {
    if (houses.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Text(
            "No houses found nearby",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 130.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ItemCount,
        itemBuilder: (context, index) {
          final house = houses[index];

          // Build full image URL
          final imageUrl = house.imageUrl.isNotEmpty
              ? (house.imageUrl.startsWith("http")
              ? house.imageUrl
              : "$_baseImageUrl${house.imageUrl}")
              : null;

          final place =
          house.place.isNotEmpty ? house.place : "Unknown location";

          final priceDisplay = house.price == 0
              ? "N/A"
              : house.price % 1 == 0
              ? "\$${house.price.toInt()}"
              : "\$${house.price.toStringAsFixed(2)}";

          final title = house.title.isNotEmpty ? house.title : "No title";

          return Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: imageUrl != null
                      ? Image.network(
                    imageUrl,
                    width: 120.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 120.w,
                        height: 100.h,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        _fallbackImage(),
                  )
                      : _fallbackImage(),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 15.h),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: Colors.grey, size: 20),
                        SizedBox(width: 5.w),
                        Text(
                          place,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      priceDisplay,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _fallbackImage() {
    return Container(
      width: 120,
      height: 100,
      color: Colors.grey[300],
      child: Icon(Icons.home, color: Colors.grey[600], size: 40),
    );
  }
}