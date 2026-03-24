import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/widgets/custom_snackbar.dart';
import '../../../themes/app_themes.dart';
import '../Model/my_houses_model.dart';
import '../bloc/my_houses_bloc.dart';
import '../bloc/my_houses_event.dart';
import '../bloc/my_houses_state.dart';

class EditHousePage extends StatefulWidget {
  final MyHouseModel house;

  const EditHousePage({required this.house, super.key});

  @override
  State<EditHousePage> createState() => _EditHousePageState();
}

class _EditHousePageState extends State<EditHousePage> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.house.title);
    descController = TextEditingController(text: widget.house.description);
    priceController = TextEditingController(
      text: widget.house.price.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit House",
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
            Navigator.pop(context); // ✅ go back after successful update
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.buildSnackBar(
                message: state.error!,
                bgColor: Colors.red,
                context: context,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header info
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          "You can update the title, description and price of your house.",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.h),

                _buildLabel("Title"),
                SizedBox(height: 8.h),
                TextField(
                  controller: titleController,
                  decoration: _inputDecoration(
                    "Enter house title",
                    Icons.home_outlined,
                  ),
                ),
                SizedBox(height: 20.h),

                _buildLabel("Description"),
                SizedBox(height: 8.h),
                TextField(
                  controller: descController,
                  maxLines: 5,
                  decoration: _inputDecoration(
                    "Describe your house",
                    Icons.description_outlined,
                  ),
                ),
                SizedBox(height: 20.h),

                _buildLabel("Price per month"),
                SizedBox(height: 8.h),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                    "Enter price",
                    Icons.attach_money,
                  ).copyWith(prefixText: "\$ "),
                ),
                SizedBox(height: 40.h),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
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
                                  bgColor: Colors.red,
                                  context: context,
                                ),
                              );
                              return;
                            }
                            context.read<MyHousesBloc>().add(
                              UpdateHouse(
                                houseId: widget.house.houseId,
                                title: titleController.text.trim(),
                                description: descController.text.trim(),
                                price:
                                    double.tryParse(
                                      priceController.text.trim(),
                                    ) ??
                                    widget.house.price,
                              ),
                            );
                          },
                    child: state.isUpdating
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Save Changes",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}
