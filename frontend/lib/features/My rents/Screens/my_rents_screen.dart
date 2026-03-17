import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_house_details_screen.dart';
import '../Model/rents_model.dart';
import '../bloc/my_rents_bloc.dart';
import '../bloc/my_rents_event.dart';
import '../bloc/my_rents_state.dart';

class MyRentsScreen extends StatefulWidget {
  const MyRentsScreen({super.key});

  @override
  State<MyRentsScreen> createState() => _MyRentsScreenState();
}

class _MyRentsScreenState extends State<MyRentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RentsBloc>().add(FetchRents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "My Rents",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<RentsBloc, RentsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.rents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_outlined, size: 70, color: Colors.grey[300]),
                  SizedBox(height: 16.h),
                  Text(
                    "No rents yet",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Houses you rent will appear here",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<RentsBloc>().add(FetchRents());
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: state.rents.length,
              itemBuilder: (context, index) {
                return _buildRentItem(context, state.rents[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRentItem(BuildContext context, RentsModel house) {
    final imageUrl = house.imageUrl.isNotEmpty
        ? (house.imageUrl.startsWith("http")
        ? house.imageUrl
        : "${ApiEndpoints.imageBaseUrl}${house.imageUrl}")
        : null;

    final priceDisplay = house.price == 0
        ? "N/A"
        : house.price % 1 == 0
        ? "\$${house.price.toInt()}/month"
        : "\$${house.price.toStringAsFixed(2)}/month";

    Color statusColor = Colors.orange;
    if (house.status == "CONFIRMED") statusColor = Colors.green;
    if (house.status == "CANCELLED") statusColor = Colors.red;
    if (house.status == "COMPLETED") statusColor = Colors.blue;

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
            // ── Image ──
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

            // ── Details ──
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      house.title.isNotEmpty ? house.title : "No title",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: AppColors.primary, size: 14),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            house.place.isNotEmpty
                                ? house.place
                                : "Unknown location",
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      priceDisplay,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // ── Status Badge ──
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(color: statusColor),
                      ),
                      child: Text(
                        house.status,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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