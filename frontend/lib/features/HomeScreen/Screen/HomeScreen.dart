import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/widgets/custom_hot_deals_houses_cart.dart';
import 'package:frontend/widgets/custom_house_nearby_cart.dart';
import 'package:frontend/widgets/custom_house_recommended_cart.dart';
import 'package:frontend/widgets/custom_textfield.dart';
import '../../../services/location_service.dart';
import '../../../themes/app_themes.dart';
import '../Bloc/fetch_nearby_house/nearby_house_bloc.dart';
import '../Bloc/fetch_nearby_house/nearby_house_event.dart';
import '../Bloc/fetch_nearby_house/nearby_house_state.dart';
import '../Bloc/home_screen/home_screen_bloc.dart';
import '../Bloc/home_screen/home_screen_event.dart';
import '../Bloc/home_screen/home_screen_state.dart';
import '../Bloc/hot_deals/hot_deals_bloc.dart';
import '../Bloc/hot_deals/hot_deals_event.dart';
import '../Bloc/hot_deals/hot_deals_state.dart';
import '../Screen/all_nearby_houses_screen.dart';
import 'package:geolocator/geolocator.dart';

import 'all_hot_details_screen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  HomescreenState createState() => HomescreenState();
}

class HomescreenState extends State<Homescreen> {
  final FocusNode searchFocus = FocusNode();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("HomeScreen initialized");
    context.read<HomeScreenBloc>().add(HomeStarted());
    context.read<HotDealsBloc>().add(FetchHotDeals());
    _fetchNearbyHouses();
  }

  void _fetchNearbyHouses() async {
    try {
      print("Fetching user location...");
      Position position = await LocationService.getUserLocation();
      double lat = position.latitude;
      double long = position.longitude;
      print("User location: lat=$lat, long=$long");

      final nearbyBloc = context.read<NearbyHouseBloc>();
      print("Dispatching FetchNearbyHouses event to NearbyHouseBloc");
      nearbyBloc.add(FetchNearbyHouses(latitude: lat, longitude: long));
    } catch (e) {
      print("Nearby fetch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> dummyHouses = [
      "Assets/Images/house 2.jpg",
      "Assets/Images/house 3.jpg",
      "Assets/Images/house 4.jpg",
      "Assets/Images/house5.jpeg",
    ];

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<HomeScreenBloc, HomeScreenState>(
          listener: (context, state) {},
          builder: (context, state) {
            print(
              "HomeScreenState rebuilt: isLoading=${state.isLoading}, name=${state.name}, place=${state.place}",
            );
            return Column(
              children: [
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: state.isLoading
                          ? Text("Loading...")
                          : Text(
                              "Hello ${state.name?.split(" ")[0]}!",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.primary),
                        Padding(
                          padding: EdgeInsets.only(right: 10.w, top: 5.h),
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
                              padding: EdgeInsets.only(top: 5.h),
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

                        // ── Recommended Section ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
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
                        CustomHouseCart.houseCart(
                          ItemCount: dummyHouses.length,
                          ImagePath: dummyHouses,
                          houseName: "Pratik HomeStay",
                          location: "Biratnagar, Nepal",
                          price: "\$300",
                        ),
                        SizedBox(height: 10.h),

                        // ── Nearby Section ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Text(
                                "Nearby",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                final houses = context
                                    .read<NearbyHouseBloc>()
                                    .state
                                    .houses;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AllNearbyHousesScreen(houses: houses),
                                  ),
                                );
                              },
                              child: Text(
                                "See all",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder<NearbyHouseBloc, NearbyHouseState>(
                          builder: (context, state) {
                            print(
                              "NearbyHouseState: isLoading=${state.isLoading}, houses=${state.houses.length}, error=${state.error}",
                            );
                            if (state.isLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state.error != null) {
                              return Text("Error: ${state.error}");
                            } else if (state.houses.isEmpty) {
                              return Text("No nearby houses found");
                            } else {
                              return CustomHouseNearbyCart.customNearbyCart(
                                houses: state.houses,
                                ItemCount: state.houses.length,
                                limit: 5,
                              );
                            }
                          },
                        ),
                        SizedBox(height: 10.h),

                        // ── Hot Deals Section ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Text(
                                "Hot Deals:",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.redColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                final houses = context
                                    .read<HotDealsBloc>()
                                    .state
                                    .houses;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AllHotDealsScreen(houses: houses),
                                  ),
                                );
                              },
                              child: Text(
                                "See all",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<HotDealsBloc, HotDealsState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state.error != null) {
                              return Text("Error: ${state.error}");
                            } else if (state.houses.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Text(
                                  "No hot deals available",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            } else {
                              return CustomHotDealsHousesCart.customHotDeals(
                                houses: state.houses,
                                ItemCount: state.houses.length,
                                limit: 5,
                              );
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
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
