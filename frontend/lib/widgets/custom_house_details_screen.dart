import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/features/WishList/bloc/wishlist_bloc.dart';
import 'package:frontend/features/WishList/bloc/wishlist_event.dart';
import 'package:frontend/features/WishList/bloc/wishlist_state.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'custom_snackbar.dart';

class CustomHouseDetailScreen extends StatefulWidget {
  final String houseId;
  final String title;
  final String imageUrl;
  final String place;
  final double price;
  final double latitude;
  final double longitude;
  final String description;

  const CustomHouseDetailScreen({
    super.key,
    required this.houseId,
    required this.title,
    required this.imageUrl,
    required this.place,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.description,
  });

  @override
  State<CustomHouseDetailScreen> createState() =>
      _CustomHouseDetailScreenState();
}

class _CustomHouseDetailScreenState extends State<CustomHouseDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistBloc>().add(ResetWishlistState());
    context.read<WishlistBloc>().add(
      CheckWishlistStatus(houseId: widget.houseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageFullUrl = widget.imageUrl.isNotEmpty
        ? (widget.imageUrl.startsWith("http")
        ? widget.imageUrl
        : "${ApiEndpoints.imageBaseUrl}${widget.imageUrl}")
        : null;

    final priceDisplay = widget.price == 0
        ? "N/A"
        : widget.price % 1 == 0
        ? "\$${widget.price.toInt()}/month"
        : "\$${widget.price.toStringAsFixed(2)}/month";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24.r),
                      bottomRight: Radius.circular(24.r),
                    ),
                    child: imageFullUrl != null
                        ? Image.network(
                      imageFullUrl,
                      width: double.infinity,
                      height: 360.h,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: 360.h,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: loadingProgress
                                  .expectedTotalBytes !=
                                  null
                                  ? loadingProgress
                                  .cumulativeBytesLoaded /
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
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 6),
                                ],
                              ),
                              child: Icon(Icons.arrow_back_ios_new,
                                  color: Colors.black, size: 18),
                            ),
                          ),


                          BlocConsumer<WishlistBloc, WishlistState>(
                            listener: (context, state) {
                              if (state.message != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar.buildSnackBar(
                                    context: context,
                                    message: state.message!,
                                    bgColor: state.isWishlisted
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                );
                              }
                              if (state.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar.buildSnackBar(
                                    context: context,
                                    message: state.error!,
                                    bgColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<WishlistBloc>().add(
                                    AddToWishlist(
                                        houseId: widget.houseId),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 6),
                                    ],
                                  ),
                                  child: state.isLoading
                                      ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.red,
                                    ),
                                  )
                                      : Icon(
                                    state.isWishlisted
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title.isNotEmpty
                                ? widget.title
                                : "No title",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          priceDisplay,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),


                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: AppColors.primary, size: 20),
                        SizedBox(width: 5.w),
                        Text(
                          widget.place.isNotEmpty
                              ? widget.place
                              : "Unknown location",
                          style: TextStyle(
                              fontSize: 14.sp, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),


                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFE5B4),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star,
                                  color: Color(0xFFFFC107), size: 18),
                              SizedBox(width: 4.w),
                              Text(
                                "4.5",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "(128 reviews)",
                          style: TextStyle(
                              fontSize: 13.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    Divider(color: Colors.grey[200], thickness: 1.5),
                    SizedBox(height: 16.h),


                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      widget.description.isNotEmpty
                          ? widget.description
                          : "No description available",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Divider(color: Colors.grey[200], thickness: 1.5),
                    SizedBox(height: 16.h),


                    Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on,
                              color: AppColors.primary, size: 20),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.place.isNotEmpty
                                      ? widget.place
                                      : "Unknown location",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Lat: ${widget.latitude.toStringAsFixed(6)}, "
                                      "Lng: ${widget.longitude.toStringAsFixed(6)}",
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2)),
          ],
        ),
        child: CustomButton.button(
          texts: "Rent Now",
          onPressed: () {},
          context: context,
          padding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }

  static Widget _fallbackImage() {
    return Container(
      width: double.infinity,
      height: 360,
      color: Colors.grey[300],
      child: Icon(Icons.home, color: Colors.grey[600], size: 60),
    );
  }
}