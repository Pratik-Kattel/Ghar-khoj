import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_house_details_screen.dart';
import 'package:frontend/widgets/custom_snackbar.dart';
import '../Model/my_houses_model.dart';
import '../bloc/my_houses_bloc.dart';
import '../bloc/my_houses_event.dart';
import '../bloc/my_houses_state.dart';
import 'edit_house_screen.dart';

class MyHousesScreen extends StatefulWidget {
  const MyHousesScreen({super.key});

  @override
  State<MyHousesScreen> createState() => _MyHousesScreenState();
}

class _MyHousesScreenState extends State<MyHousesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyHousesBloc>().add(FetchMyHouses());
  }

  void _showEditDialog(BuildContext context, MyHouseModel house) {
    final titleController = TextEditingController(text: house.title);
    final descController = TextEditingController(text: house.description);
    final priceController = TextEditingController(
      text: house.price.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            "Edit House",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price",
                    prefixText: "\$",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text("Cancel"),
                ),
                BlocBuilder<MyHousesBloc, MyHousesState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: state.isUpdating
                          ? null
                          : () {
                              if (titleController.text.trim().isEmpty ||
                                  descController.text.trim().isEmpty ||
                                  priceController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar.buildSnackBar(
                                    message: "All fields are required",
                                    context: context,
                                    bgColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              context.read<MyHousesBloc>().add(
                                UpdateHouse(
                                  houseId: house.houseId,
                                  title: titleController.text.trim(),
                                  description: descController.text.trim(),
                                  price:
                                      double.tryParse(
                                        priceController.text.trim(),
                                      ) ??
                                      house.price,
                                ),
                              );
                              Navigator.pop(dialogContext);
                            },
                      child: state.isUpdating
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text("Save", style: TextStyle(color: Colors.white)),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String houseId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            "Delete House",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this house? This action cannot be undone.",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text("Cancel"),
                ),
                BlocBuilder<MyHousesBloc, MyHousesState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: state.isDeleting
                          ? null
                          : () {
                              context.read<MyHousesBloc>().add(
                                DeleteHouse(houseId: houseId),
                              );
                              Navigator.pop(dialogContext);
                            },
                      child: state.isDeleting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "My Houses",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocConsumer<MyHousesBloc, MyHousesState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.buildSnackBar(
                message: state.message!,
                bgColor: Colors.green,
                context: context,
              ),
            );
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.buildSnackBar(
                message: state.error!,
                bgColor: Colors.red,
                context: context
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.houses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_outlined, size: 70, color: Colors.grey[300]),
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
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<MyHousesBloc>().add(FetchMyHouses()),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: state.houses.length,
              itemBuilder: (context, index) {
                return _buildHouseItem(context, state.houses[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, MyHouseModel house) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                house.title,
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
                "What would you like to do?",
                style: TextStyle(fontSize: 13.sp, color: Colors.grey),
              ),
              SizedBox(height: 20.h),
              Divider(height: 1, color: Colors.grey[200]),
              SizedBox(height: 12.h),


              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                title: Text(
                  "Edit House",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "Update title, description or price",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditHousePage(house: house),
                    ),
                  );
                },
              ),

              SizedBox(height: 8.h),


              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
                title: Text(
                  "Delete House",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                subtitle: Text(
                  "This action cannot be undone",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteDialog(context, house.houseId);
                },
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHouseItem(BuildContext context, MyHouseModel house) {
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
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                  ),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          width: 120.w,
                          height: 130.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _fallbackImage(),
                        )
                      : _fallbackImage(),
                ),
                SizedBox(width: 12.w),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 14.h,
                      bottom: 14.h,
                      right: 40.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          house.title.isNotEmpty ? house.title : "No title",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            priceDisplay,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        house.averageRating > 0
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Color(0xFFFFC107),
                                    size: 14,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    house.averageRating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "(${house.totalReviews})",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Icon(
                                    Icons.star_border,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "No reviews yet",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 8.h,
              right: 8.w,
              child: GestureDetector(
                onTap: () => _showOptionsBottomSheet(context, house),
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.more_vert, size: 18, color: Colors.black87),
                ),
              ),
            ),
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
