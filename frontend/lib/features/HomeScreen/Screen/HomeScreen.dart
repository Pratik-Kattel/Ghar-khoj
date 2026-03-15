import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/features/HomeScreen/Bloc/home_screen_bloc.dart';
import 'package:frontend/features/HomeScreen/Bloc/home_screen_event.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_house_nearby_cart.dart';
import 'package:frontend/widgets/custom_house_recommended_cart.dart';
import 'package:frontend/widgets/custom_textfield.dart';

import '../Bloc/home_screen_state.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  HomescreenState createState() => HomescreenState();
}

class HomescreenState extends State<Homescreen> {
  void initState() {
    super.initState();
    context.read<HomeScreenBloc>().add(HomeStarted());
  }

  @override
  Widget build(BuildContext context) {
    List<String> houses = [
      "Assets/Images/house 2.jpg",
      "Assets/Images/house 3.jpg",
      "Assets/Images/house 4.jpg",
      "Assets/Images/house5.jpeg",
    ];
    final FocusNode searchFocus = FocusNode();
    final TextEditingController searchController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<HomeScreenBloc, HomeScreenState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(left: 15.w),
                      child: state.isLoading
                          ? Text("Loading...")
                          : Text(
                              "Hello ${state.name}!",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.primary),
                        Padding(
                          padding: EdgeInsetsGeometry.only(
                            right: 10.w,
                            top: 5.h,
                          ),
                          child: Text(
                            state.place ?? "Loading..",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        InkWell(
                          onTap: () {},
                          child: CustomTextField.textField(
                            width: 1.5,
                            hintText: "Search property",
                            borderColor: Colors.grey,
                            focus: searchFocus,
                            controller: searchController,
                            prefixIcon: Icon(
                              Icons.search_outlined,
                              color: AppColors.primary,
                            ),
                            contentPadding: 19,
                            iconPadding: 10,
                            suffixIcon: Padding(
                              padding: EdgeInsetsGeometry.only(top: 5.h),
                              child: IconButton(
                                color: AppColors.primary,
                                onPressed: () {},
                                icon: Icon(Icons.tune),
                              ),
                            ),
                            Validator: (value) {},
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.only(left: 10.w),
                              child: Text(
                                "Recommended",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "See all",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          child: CustomHouseCart.houseCart(
                            ItemCount: houses.length,
                            ImagePath: houses,
                            houseName: "Pratik HomeStay",
                            location: "Biratnagar, Nepal",
                            price: "\$300",
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.only(left: 10.w),
                              child: Text(
                                "Nearby",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "See all",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: CustomHouseNearbyCart.customNearbyCart(
                            houses: houses,
                            ItemCount: houses.length,
                          ),
                        ),
                        CustomHouseNearbyCart.customNearbyCart(
                          houses: houses,
                          ItemCount: houses.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
