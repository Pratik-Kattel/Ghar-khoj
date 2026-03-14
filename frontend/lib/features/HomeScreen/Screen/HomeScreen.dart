import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/features/HomeScreen/Bloc/home_screen_bloc.dart';
import 'package:frontend/features/HomeScreen/Bloc/home_screen_event.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/get_user_data.dart';
import 'package:frontend/themes/app_themes.dart';
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
                SingleChildScrollView(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.only(left: 10.w),
                            child: Text(
                              "Recommended",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          TextButton(onPressed: () {}, child: Text("See all")),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        height: 200.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: houses.length,
                          separatorBuilder: (context,index)=>SizedBox(width: 10.w,),
                          itemBuilder: (context,index){
                            return ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(12.r),
                              child: Image.asset(houses[index]),
                            );
                          },
                        ),
                      ),
                    ],
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
