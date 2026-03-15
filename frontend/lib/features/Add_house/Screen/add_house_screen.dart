import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_textfield.dart';
import 'package:frontend/widgets/custom_snackbar.dart';
import '../bloc/add_house_bloc.dart';
import '../bloc/add_house_event.dart';
import '../bloc/add_house_state.dart';

class UploadHouseScreen extends StatefulWidget {
  const UploadHouseScreen({super.key});

  @override
  State<UploadHouseScreen> createState() => _UploadHouseScreenState();
}

class _UploadHouseScreenState extends State<UploadHouseScreen> {
  final picker = ImagePicker();
  bool _isDialogOpen = false;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final countryController = TextEditingController();
  final placeController = TextEditingController();

  final FocusNode titleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode countryFocus = FocusNode();
  final FocusNode placeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    titleFocus.addListener(() => setState(() {}));
    descriptionFocus.addListener(() => setState(() {}));
    priceFocus.addListener(() => setState(() {}));
    countryFocus.addListener(() => setState(() {}));
    placeFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    titleFocus.dispose();
    descriptionFocus.dispose();
    priceFocus.dispose();
    countryFocus.dispose();
    placeFocus.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    countryController.dispose();
    placeController.dispose();
    super.dispose();
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<HouseUploadBloc>().add(HouseImagePicked(File(pickedFile.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryScaffold,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("List Your Property 🏠"),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 75.h,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: BlocConsumer<HouseUploadBloc, HouseUploadState>(
          listener: (context, state) {
            if (state.isSubmitting && !_isDialogOpen) {
              _isDialogOpen = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                const Center(child: CircularProgressIndicator()),
              );
            }

            if (!state.isSubmitting && _isDialogOpen) {
              _isDialogOpen = false;
              Navigator.pop(context);
            }

            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                  message: state.errorMessage,
                  context: context,
                  bgColor: Colors.white,
                  messageColor: Colors.red,
                ),
              );
            }

            if (state.isSuccess && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                  message: state.message,
                  context: context,
                  bgColor: Colors.black,
                  messageColor: Colors.green,
                  icon: Icons.verified,
                  iconColor: Colors.green,
                ),
              );
              titleController.clear();
              descriptionController.clear();
              priceController.clear();
              countryController.clear();
              placeController.clear();

              // Reset the focus nodes (optional)
              titleFocus.unfocus();
              descriptionFocus.unfocus();
              priceFocus.unfocus();
              countryFocus.unfocus();
              placeFocus.unfocus();

              // Reset bloc to initial state
              context.read<HouseUploadBloc>().add(HouseResetState());
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 0.002.sh),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Text(
                      "Fill in the details below to list your property",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Image Picker
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 180.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: state.imageFile != null
                                ? AppColors.primary
                                : AppColors.grey,
                            width: 2,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: state.imageFile != null
                            ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              state.imageFile!,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.55),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 14.sp),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Change Photo",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              color: AppColors.primary,
                              size: 40.sp,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Tap to add property photo",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "JPG, PNG supported",
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),

                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: CustomTextField.textField(
                      width: 2,
                      contentPadding: 20,
                      iconPadding: 17,
                      hintText: "Enter Title",
                      borderColor: titleFocus.hasFocus
                          ? AppColors.primary
                          : AppColors.grey,
                      focus: titleFocus,
                      controller: titleController,
                      prefixIcon: Icon(
                        Icons.home_outlined,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                      Validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Title should not be empty";
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 25.h),

                  // Description
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: CustomTextField.textField(
                      width: 2,
                      contentPadding: 20,
                      iconPadding: 17,
                      hintText: "Enter Description",
                      maxLines: 3,
                      borderColor: descriptionFocus.hasFocus
                          ? AppColors.primary
                          : AppColors.grey,
                      focus: descriptionFocus,
                      controller: descriptionController,
                      prefixIcon: Icon(
                        Icons.description_outlined,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                      Validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Description should not be empty";
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 25.h),

                  // Price
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: CustomTextField.textField(
                      width: 2,
                      contentPadding: 20,
                      iconPadding: 17,
                      hintText: "Enter Price",
                      keyboardType: TextInputType.number,
                      borderColor: priceFocus.hasFocus
                          ? AppColors.primary
                          : AppColors.grey,
                      focus: priceFocus,
                      controller: priceController,
                      prefixIcon: Icon(
                        Icons.attach_money_rounded,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                      Validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Price should not be empty";
                        }
                        if (double.tryParse(value) == null) {
                          return "Enter a valid price";
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 25.h),

                  // Country
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: CustomTextField.textField(
                      width: 2,
                      contentPadding: 20,
                      iconPadding: 17,
                      hintText: "Enter Country",
                      borderColor: countryFocus.hasFocus
                          ? AppColors.primary
                          : AppColors.grey,
                      focus: countryFocus,
                      controller: countryController,
                      prefixIcon: Icon(
                        Icons.flag_outlined,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                      Validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Country should not be empty";
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 25.h),

                  // Place
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: CustomTextField.textField(
                      width: 2,
                      contentPadding: 20,
                      iconPadding: 17,
                      hintText: "Enter Place / City",
                      borderColor: placeFocus.hasFocus
                          ? AppColors.primary
                          : AppColors.grey,
                      focus: placeFocus,
                      controller: placeController,
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                      Validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Place should not be empty";
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Upload Button
                  CustomButton.button(
                    padding: EdgeInsets.symmetric(horizontal: 0.25.sw),
                    texts: "Upload House",
                    context: context,
                    onPressed: () {
                      final bloc = context.read<HouseUploadBloc>();
                      bloc.add(HouseTitleChanged(titleController.text));
                      bloc.add(HouseDescriptionChanged(descriptionController.text));
                      bloc.add(HousePriceChanged(
                          double.tryParse(priceController.text) ?? 0));
                      bloc.add(HouseCountryChanged(countryController.text));
                      bloc.add(HousePlaceChanged(placeController.text));
                      bloc.add(HouseUploadSubmitted());
                    },
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}