import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/features/WishList/bloc/wishlist_bloc.dart';
import 'package:frontend/features/WishList/bloc/wishlist_event.dart';
import 'package:frontend/features/WishList/bloc/wishlist_state.dart';
import 'package:frontend/services/get_user_data.dart';
import 'package:frontend/services/stripe_service.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_button.dart';
import '../features/My houses/bloc/my_rents_bloc.dart';
import '../features/My houses/bloc/my_rents_event.dart';
import '../features/My houses/bloc/my_rents_state.dart';
import 'custom_snackbar.dart';
import '../features/Review and ratings/Model/review_model.dart';
import '../features/Review and ratings/bloc/reviews_bloc.dart';
import '../features/Review and ratings/bloc/reviews_event.dart';
import '../features/Review and ratings/bloc/reviews_state.dart';

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
  String? role;

  @override
  void initState() {
    super.initState();
    context.read<WishlistBloc>().add(ResetWishlistState());
    context.read<WishlistBloc>().add(
      CheckWishlistStatus(houseId: widget.houseId),
    );
    context.read<ReviewBloc>().add(ResetReviewState());
    context.read<ReviewBloc>().add(FetchAverageRating(houseId: widget.houseId));
    context.read<ReviewBloc>().add(FetchReviews(houseId: widget.houseId));
    context.read<ReviewBloc>().add(CheckReviewStatus(houseId: widget.houseId));
    context.read<RentsBloc>().add(ResetBookingStatus());
    context.read<RentsBloc>().add(CheckBookingStatus(houseId: widget.houseId));
    _getUserRole();
  }

  Future<String?> _getUserRole() async {
    final fetchedRole = await GetUserDataRepo.getUserRole();
    setState(() {
      role = fetchedRole;
    });
  }

  void _showAddReviewDialog(BuildContext context) {
    int selectedRating = 0;
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                "Add Review",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              content: SizedBox(
                height: 230.h,
                width: 400.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rating",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: List.generate(5, (i) {
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedRating = i + 1;
                            });
                          },
                          child: Icon(
                            i < selectedRating ? Icons.star : Icons.star_border,
                            color: Color(0xFFFFC107),
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Comment",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Write your review...",
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
                    BlocBuilder<ReviewBloc, ReviewState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          onPressed: state.isSubmitting
                              ? null
                              : () {
                                  if (selectedRating == 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Please select a rating"),
                                      ),
                                    );
                                    return;
                                  }
                                  if (commentController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Please write a comment"),
                                      ),
                                    );
                                    return;
                                  }
                                  context.read<ReviewBloc>().add(
                                    SubmitReview(
                                      houseId: widget.houseId,
                                      rating: selectedRating,
                                      comment: commentController.text.trim(),
                                    ),
                                  );
                                  Navigator.pop(dialogContext);
                                },
                          child: state.isSubmitting
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Submit",
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
      },
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.tenantName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating ? Icons.star : Icons.star_border,
                    color: Color(0xFFFFC107),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            review.comment,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
          ),
        ],
      ),
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
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
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
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
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
                                    color: Colors.black12,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                                size: 18,
                              ),
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
                                    AddToWishlist(houseId: widget.houseId),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                      ),
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
                            widget.title.isNotEmpty ? widget.title : "No title",
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
                        Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          widget.place.isNotEmpty
                              ? widget.place
                              : "Unknown location",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    BlocBuilder<ReviewBloc, ReviewState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFE5B4),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Color(0xFFFFC107),
                                    size: 18,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    state.averageRating == 0.0
                                        ? "N/A"
                                        : state.averageRating.toStringAsFixed(
                                            1,
                                          ),
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
                              "(${state.totalReviews} reviews)",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      },
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
                          Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 20,
                          ),
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
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Divider(color: Colors.grey[200], thickness: 1.5),
                    SizedBox(height: 16.h),
                    BlocBuilder<ReviewBloc, ReviewState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Reviews",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            if (role == 'TENANT')
                              if (!state.hasReviewed)
                                TextButton(
                                  onPressed: () =>
                                      _showAddReviewDialog(context),
                                  child: Text(
                                    "Add Review",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                            if (state.hasReviewed)
                              Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Reviewed",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 8.h),
                    BlocConsumer<ReviewBloc, ReviewState>(
                      listener: (context, state) {
                        if (state.message != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message!),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
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
                        if (state.reviews.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Text(
                              "No reviews yet. Be the first to review!",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.reviews.length,
                          itemBuilder: (context, index) {
                            return _buildReviewItem(state.reviews[index]);
                          },
                        );
                      },
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: role == null
          ? SizedBox(height: 80.h, child: CircularProgressIndicator())
          : role == 'TENANT'
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: BlocConsumer<RentsBloc, RentsState>(
                listener: (context, state) {
                  if (state.message != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message!),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  if (state.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error!),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.isBooked) {
                    String formatDate(String? raw) {
                      if (raw == null) return '';
                      try {
                        final dt = DateTime.parse(raw);
                        const months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec',
                        ];
                        return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
                      } catch (_) {
                        return raw;
                      }
                    }

                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.orange[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event_busy,
                            color: Colors.orange[700],
                            size: 22,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Already Booked",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.orange[800],
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "${formatDate(state.bookedStartDate)} → ${formatDate(state.bookedEndDate)}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.orange[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return CustomButton.button(
                    texts: state.isAdding ? "Processing..." : "Rent Now",
                    onPressed: state.isAdding
                        ? null
                        : () async {
                            final result = await _showDatePickerDialog(context);
                            if (result == null) return;
                            final startDate = result['startDate']!;
                            final endDate = result['endDate']!;
                            final totalAmount = result['totalAmount']!;
                            final paymentSuccess = await StripeService.instance
                                .makePayment(
                                  houseId: widget.houseId,
                                  amount: double.parse(totalAmount),
                                  startDate: startDate,
                                  endDate: endDate,
                                );
                            if (paymentSuccess) {
                              context.read<RentsBloc>().add(CheckBookingStatus(houseId: widget.houseId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Payment successful! House rented.",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Payment cancelled or failed."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    context: context,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  );
                },
              ),
            )
          : null,
    );
  }

  Future<Map<String, String>?> _showDatePickerDialog(
    BuildContext context,
  ) async {
    DateTime? startDate;
    DateTime? endDate;

    return await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            int months = 0;
            double totalAmount = 0;

            if (startDate != null && endDate != null) {
              months = ((endDate!.difference(startDate!).inDays) / 30).ceil();
              totalAmount = months * widget.price;
            }

            return AlertDialog(
              title: Center(
                child: Text(
                  "Select Rental Period",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              content: SizedBox(
                width: 400.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Start Date
                    Text(
                      "Start Date",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            startDate = picked;
                            if (endDate != null &&
                                endDate!.isBefore(startDate!)) {
                              endDate = null;
                            }
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          startDate == null
                              ? "Select start date"
                              : "${startDate!.day}/${startDate!.month}/${startDate!.year}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: startDate == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // End Date
                    Text(
                      "End Date",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () async {
                        if (startDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select start date first"),
                            ),
                          );
                          return;
                        }
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate!.add(Duration(days: 30)),
                          firstDate: startDate!.add(Duration(days: 1)),
                          lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                        );
                        if (picked != null) {
                          setDialogState(() => endDate = picked);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          endDate == null
                              ? "Select end date"
                              : "${endDate!.day}/${endDate!.month}/${endDate!.year}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: endDate == null ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ),

                    // Total
                    if (startDate != null && endDate != null) ...[
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$months month(s)",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "\$${totalAmount.toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: startDate == null || endDate == null
                          ? null
                          : () {
                              final fmt = (DateTime d) =>
                                  "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
                              final months =
                                  ((endDate!.difference(startDate!).inDays) /
                                          30)
                                      .ceil();
                              final total = months * widget.price;
                              Navigator.pop(dialogContext, {
                                "startDate": fmt(startDate!),
                                "endDate": fmt(endDate!),
                                "totalAmount": total.toString(),
                              });
                            },
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
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
