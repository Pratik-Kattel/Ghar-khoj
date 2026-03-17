import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_house_details_screen.dart';
import '../bloc/search_property_bloc.dart';
import '../bloc/search_property_event.dart';
import '../bloc/search_property_state.dart';
import '../model/search_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = "none";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    context.read<SearchBloc>().add(
      SearchHouses(query: query, sortBy: _selectedSort),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filter by Price",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildSortOption(
                    context: context,
                    setSheetState: setSheetState,
                    label: "Default",
                    value: "none",
                    icon: Icons.sort,
                  ),
                  _buildSortOption(
                    context: context,
                    setSheetState: setSheetState,
                    label: "Price: Low to High",
                    value: "low_to_high",
                    icon: Icons.arrow_upward,
                  ),
                  _buildSortOption(
                    context: context,
                    setSheetState: setSheetState,
                    label: "Price: High to Low",
                    value: "high_to_low",
                    icon: Icons.arrow_downward,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _search();
                      },
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOption({
    required BuildContext context,
    required StateSetter setSheetState,
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedSort == value;
    return GestureDetector(
      onTap: () {
        setSheetState(() => _selectedSort = value);
        setState(() => _selectedSort = value);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? AppColors.primary : Colors.grey,
                size: 20),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.black,
              ),
            ),
            Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:
          Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
          onPressed: () {
            context.read<SearchBloc>().add(ClearSearch());
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search property...",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 15.sp),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.tune,
                color: _selectedSort != "none"
                    ? AppColors.primary
                    : Colors.grey,
              ),
              onPressed: () => _showFilterBottomSheet(context),
            ),
          ),
          onChanged: (value) {
            if (value.trim().isNotEmpty) {
              context.read<SearchBloc>().add(
                SearchHouses(
                  query: value.trim(),
                  sortBy: _selectedSort,
                ),
              );
            } else {
              context.read<SearchBloc>().add(ClearSearch());
            }
          },
        ),
      ),
      body: Column(
        children: [
          // ── Active Filter Chip ──
          if (_selectedSort != "none")
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 4.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(
                    _selectedSort == "low_to_high"
                        ? "Price: Low to High"
                        : "Price: High to Low",
                    style:
                    TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                  backgroundColor: AppColors.primary,
                  deleteIcon:
                  Icon(Icons.close, size: 16, color: Colors.white),
                  onDeleted: () {
                    setState(() => _selectedSort = "none");
                    _search();
                  },
                ),
              ),
            ),

          // ── Results ──
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (_searchController.text.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search,
                            size: 60, color: Colors.grey[300]),
                        SizedBox(height: 16.h),
                        Text(
                          "Search for a property",
                          style: TextStyle(
                              fontSize: 16.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (state.error != null) {
                  return Center(
                    child: Text(
                      "Error: ${state.error}",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state.results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_outlined,
                            size: 60, color: Colors.grey[300]),
                        SizedBox(height: 16.h),
                        Text(
                          "No houses found",
                          style: TextStyle(
                              fontSize: 16.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 12.h),
                  itemCount: state.results.length,
                  itemBuilder: (context, index) {
                    return _buildSearchItem(
                        context, state.results[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchItem(BuildContext context, SearchModel house) {
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
              place: "",
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
                      house.title.isNotEmpty ? house.title : "No title",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                    SizedBox(height: 4.h),
                    if (house.averageRating > 0)
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: Color(0xFFFFC107), size: 14),
                          SizedBox(width: 3.w),
                          Text(
                            house.averageRating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "(${house.totalReviews} reviews)",
                            style: TextStyle(
                                fontSize: 11.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
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