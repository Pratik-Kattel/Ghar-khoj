import 'dart:core';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/constants/stripe_keys.dart';
import 'package:frontend/features/Add_house/bloc/add_house_bloc.dart';
import 'package:frontend/features/Bottom_Navigator/Bottom_Navigator.dart';
import 'package:frontend/features/My houses/Repository/my_houses_repo.dart';
import 'package:frontend/features/My%20houses/bloc/my_houses_bloc.dart';
import 'package:frontend/features/Recommendation/Repository/recommendation_repo.dart';
import 'package:frontend/features/Recommendation/bloc/recommendation_bloc.dart';
import 'package:frontend/features/Review%20and%20ratings/Repository/review_repo.dart';
import 'package:frontend/features/Review%20and%20ratings/bloc/reviews_bloc.dart';
import 'package:frontend/features/Search%20Property/Repository/search_repo.dart';
import 'package:frontend/features/Search%20Property/bloc/search_property_bloc.dart';
import 'package:frontend/features/Settings/Bloc/profile_page/profile_page_bloc.dart';
import 'package:frontend/features/Settings/Repository/change_user_name_repo.dart';
import 'package:frontend/features/Theme_switch/cubit/theme_switch_cubit.dart';
import 'package:frontend/features/WishList/Repository/wishlist_repo.dart';
import 'package:frontend/features/WishList/bloc/wishlist_bloc.dart';
import 'package:frontend/features/auth/Repository/forgot_password/change_password_repo.dart';
import 'package:frontend/features/auth/Repository/forgot_password/validate_email_repo.dart';
import 'package:frontend/features/auth/Repository/forgot_password/validate_otp_repo.dart';
import 'package:frontend/features/auth/Repository/login/location_response_repo.dart';
import 'package:frontend/features/auth/Repository/signup/signup_repo.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:frontend/features/auth/bloc/signup/signup_bloc.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/features/splash/screens/splash_screen.dart';
import 'package:frontend/services/get_user_data.dart';
import 'package:frontend/services/secure_storage.dart';
import 'package:frontend/services/stripe_service.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './features/auth/bloc/login/login_bloc.dart';
import './features/auth/Repository/login/login_repo.dart';
import 'features/Add_house/Repository/upload_house-repo.dart';
import 'features/Admin Dashboard/Repository/admin_dashboard_repo.dart';
import 'features/Admin Dashboard/Repository/admin_houses_repo.dart';
import 'features/Admin Dashboard/bloc/admin_dashboard_bloc.dart';
import 'features/Admin Dashboard/bloc/admin_houses_bloc.dart';
import 'features/Home/Bloc/fetch_nearby_house/nearby_house_bloc.dart';
import 'features/Home/Bloc/home_screen/home_screen_bloc.dart';
import 'features/Home/Bloc/hot_deals/hot_deals_bloc.dart';
import 'features/Home/Repository/hotdeals_repo.dart';
import 'features/Home/Repository/nearby_house_repo.dart';
import 'features/Landlord Request/Repository/landlord_request_repo.dart';
import 'features/Landlord Request/bloc/landlord_request_bloc.dart';
import 'features/My rents/Repository/rents_repo.dart';
import 'features/My rents/bloc/my_rents_bloc.dart';

// The main entry point of the application.
void main() async {
  // Ensures that widget binding is initialized before any asynchronous calls.
  await WidgetsFlutterBinding.ensureInitialized();
  
  // Set the publishable key for Stripe integration.
  Stripe.publishableKey = publishableKey;
  
  // Retrieve the stored authentication token if available.
  String? token = await SecureStorage.getToken();
  String? role;
  
  // If a token exists, fetch the user's role.
  if (token != null) {
    role = await GetUserDataRepo.getUserRole();
  }

  // Initialize the core API client and various repositories.
  final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
  final loginRepo = LoginRepository(apiClient: apiClient);
  final signUpRepo = SignupRepository(apiClient: apiClient);
  final validateEmailRepository = ValidateEmailRepository(apiClient: apiClient);
  final validateOTPRepository = ValidateOtpRepo(apiClient: apiClient);
  final changePasswordRepo = ChangePasswordRepo(apiClient: apiClient);
  final locationResponseRepo = LocationResponseRepo(apiClient: apiClient);
  final getUserDataRepo = GetUserDataRepo(apiClient);
  final changeUsernameRepo = ChangeUserNameRepo(apiClient: apiClient);
  final houseRepo = HouseRepository(apiClient: apiClient);
  final nearbyHouserepo = NearbyHouseRepo(apiClient: apiClient);
  final hotDealsRepo = HotDealsRepo(apiClient: apiClient);
  final wishlistrepo = WishlistRepo(apiClient: apiClient);
  final reviewRepo = ReviewRepo(apiClient: apiClient);
  final recommendedRepo = RecommendedRepo(apiClient: apiClient);
  final searchSystemRepo = SearchRepo(apiClient: apiClient);
  final myRentsRepo = RentsRepo(apiClient: apiClient);
  final myHousesRepo = MyHousesRepo(apiClient: apiClient);
  final landlordRequestRepo = LandlordRequestRepo(apiClient: apiClient);
  final adminDashboardRepo = AdminDashboardRepo(apiClient: apiClient);
  final adminHousesRepo = AdminHousesRepo(apiClient: apiClient);

  // Initialize Stripe service with the API client.
  StripeService.init(apiClient);
  
  runApp(
    MultiBlocProvider(
      // Provide all the necessary Blocs and Cubits to the application widget tree.
      providers: [
        BlocProvider(create: (_) => LoginBloc(repository: loginRepo, locationResponseRepo: locationResponseRepo)),
        BlocProvider(create: (_) => SignupBloc(signupRepository: signUpRepo)),
        BlocProvider(create: (_) => ForgotPasswordBloc(validateEmailRepository: validateEmailRepository)),
        BlocProvider(create: (_) => PasswordChangeBloc(changePasswordRepo: changePasswordRepo)),
        BlocProvider(create: (_) => HomeScreenBloc(getUserDataRepo: getUserDataRepo, locationResponseRepo: locationResponseRepo)),
        BlocProvider(create: (_) => PasswordChangeBloc(changePasswordRepo: changePasswordRepo)),
        BlocProvider(create: (_) => OTPValidationBloc(validateOtpRepo: validateOTPRepository)),
        BlocProvider(create: (_) => HouseUploadBloc(repository: houseRepo)),
        BlocProvider(create: (_) => NearbyHouseBloc(repo: nearbyHouserepo)),
        BlocProvider(create: (_) => ProfilePageBloc(changeUserNameRepo: changeUsernameRepo)),
        BlocProvider(create: (_) => HotDealsBloc(repo: hotDealsRepo)),
        BlocProvider(create: (_) => ReviewBloc(repo: reviewRepo)),
        BlocProvider(create: (_) => WishlistBloc(repo: wishlistrepo)),
        BlocProvider(create: (_) => RecommendedBloc(repo: recommendedRepo)),
        BlocProvider(create: (_) => SearchBloc(repo: searchSystemRepo)),
        BlocProvider(create: (_) => RentsBloc(repo: myRentsRepo)),
        BlocProvider(create: (_) => MyHousesBloc(repo: myHousesRepo)),
        BlocProvider(create: (_) => LandlordRequestBloc(repo: landlordRequestRepo)),
        BlocProvider(create: (_) => AdminDashboardBloc(repo: adminDashboardRepo)),
        BlocProvider(create: (_) => AdminHousesBloc(repo: adminHousesRepo)),
        BlocProvider(create: (_) => ThemeSwitchCubit())
      ],
      // Pass the initial login status and user role to the app widget.
      child: myApp(isLoggedIn: token != null, role: role ?? 'TENANT'),
    ),
  );
}

// The root application widget.
class myApp extends StatelessWidget {
  final bool isLoggedIn;
  final String role;
  
  myApp({super.key, required this.isLoggedIn, required this.role});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive UI design.
    return ScreenUtilInit(
      designSize: Size(390, 844),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.purpleTheme,
        routes: AppRoutes.routes,
        darkTheme: AppThemes.darkTheme,
        // Navigate to BottomNavigator if logged in, otherwise show the SplashScreen.
        home: isLoggedIn
            ? BottomNavigator(role: role)
            : SplashScreen(),
      ),
    );
  }
}
