import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/get_user_data.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_house_details_screen.dart';

class MyHousesScreen extends StatefulWidget {
  const MyHousesScreen({super.key});

  @override
  State<MyHousesScreen> createState() => _MyHousesScreenState();
}

class _MyHousesScreenState extends State<MyHousesScreen> {
  List<dynamic> _houses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMyHouses();
  }

  Future<void> _fetchMyHouses() async {
    try {
      final email = await GetUserDataRepo.getUserEmail();
      if (email == null) throw Exception("User not logged in");
      final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
      final res = await apiClient.get("${ApiEndpoints.myHouses}/$email");
      setState(() {
        _houses = res["houses"] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "My Houses",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Text(
          "Error: $_error",
          style: TextStyle(color: Colors.red),
        ),
      )
          : _houses.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_outlined,
                size: 70, color: Colors.grey[300]),
            SizedBox(height: 16.h),
            Text(
              "No houses uploaded yet",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Add your first house to get started",
              style: TextStyle(
                  fontSize: 14.sp, color: Colors.grey),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchMyHouses,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(
              horizontal: 16.w, vertical: 12.h),
          itemCount: _houses.length,
          itemBuilder: (context, index) {
            return _buildHouseItem(context, _houses[index]);
          },
        ),
      ),
    );
  }

  Widget _buildHouseItem(
      BuildContext context, Map<String, dynamic> house) {
    final imageUrl = (house["image_url"] ?? "").isNotEmpty
        ? ((house["image_url"] as String).startsWith("http")
        ? house["image_url"]
        : "${ApiEndpoints.imageBaseUrl}${house["image_url"]}")
        : null;

    final price =
        double.tryParse(house["price"]?.toString() ?? "0") ?? 0.0;
    final priceDisplay = price == 0
        ? "N/A"
        : price % 1 == 0
        ? "\$${price.toInt()}/month"
        : "\$${price.toStringAsFixed(2)}/month";

    final avgRating = house["average_rating"] == null
        ? 0.0
        : double.tryParse(house["average_rating"].toString()) ?? 0.0;

    final totalReviews =
        int.tryParse(house["total_reviews"]?.toString() ?? "0") ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomHouseDetailScreen(
              houseId: house["house_id"] ?? "",
              title: house["title"] ?? "",
              imageUrl: house["image_url"] ?? "",
              place: "",
              price: price,
              latitude: (house["latitude"] as num?)?.toDouble() ?? 0.0,
              longitude: (house["longitude"] as num?)?.toDouble() ?? 0.0,
              description: house["description"] ?? "",
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: imageUrl != null
                  ? Image.network(
                imageUrl,
                width: 110.w,
                height: 110.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _fallbackImage(),
              )
                  : _fallbackImage(),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      house["title"] ?? "No title",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      priceDisplay,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (avgRating > 0)
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: Color(0xFFFFC107), size: 14),
                          SizedBox(width: 3.w),
                          Text(
                            avgRating.toStringAsFixed(1),
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.black),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "($totalReviews reviews)",
                            style: TextStyle(
                                fontSize: 11.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                    if (avgRating == 0)
                      Text(
                        "No reviews yet",
                        style:
                        TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
          ],
        ),
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: 110,
      height: 110,
      color: Colors.grey[300],
      child: Icon(Icons.home, color: Colors.grey[600], size: 35),
    );
  }
}