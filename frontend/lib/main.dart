import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/features/Add_house/bloc/add_house_bloc.dart';
import 'package:frontend/features/Bottom_Navigator/Bottom_Navigator.dart';
import 'package:frontend/features/HomeScreen/Bloc/home_screen_bloc.dart';
import 'package:frontend/features/HomeScreen/Screen/HomeScreen.dart';
import 'package:frontend/features/Settings/Bloc/profile_page/profile_page_bloc.dart';
import 'package:frontend/features/Settings/Repository/change_user_name_repo.dart';
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
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './features/auth/bloc/login/login_bloc.dart';
import './features/auth/Repository/login/login_repo.dart';
import 'features/Add_house/Repository/upload_house-repo.dart';

void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  String?token=await SecureStorage.getToken();
  final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
  final loginRepo = LoginRepository(apiClient: apiClient);
  final signUpRepo = SignupRepository(apiClient: apiClient);
  final validateEmailRepository = ValidateEmailRepository(apiClient: apiClient);
  final validateOTPRepository=ValidateOtpRepo(apiClient:apiClient);
  final changePasswordRepo=ChangePasswordRepo(apiClient: apiClient);
  final locationResponseRepo=LocationResponseRepo(apiClient: apiClient);
  final getUserDataRepo=GetUserDataRepo(apiClient);
  final changeUsernameRepo=ChangeUserNameRepo(apiClient: apiClient);
  final houseRepo = HouseRepository(apiClient: apiClient);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(repository: loginRepo,locationResponseRepo: locationResponseRepo)),
        BlocProvider(create: (_) => SignupBloc(signupRepository: signUpRepo)),
        BlocProvider(
          create: (_) => ForgotPasswordBloc(
            validateEmailRepository: validateEmailRepository,
          ),
        ),
        BlocProvider(create: (_)=>OTPValidationBloc(validateOtpRepo: validateOTPRepository)),
        BlocProvider(create: (_)=>PasswordChangeBloc(changePasswordRepo: changePasswordRepo)),
        BlocProvider(create: (_)=>HomeScreenBloc(getUserDataRepo: getUserDataRepo, locationResponseRepo: locationResponseRepo)),
        BlocProvider(create: (_)=>HouseUploadBloc(repository: houseRepo)),
        BlocProvider(create: (_)=>ProfilePageBloc(changeUserNameRepo: changeUsernameRepo),
        )],
      child:  myApp(isLoggedIn:token!=null),
    ),
  );
}

class myApp extends StatelessWidget {
  final bool isLoggedIn;
  myApp({super.key,required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.purpleTheme,
        routes: AppRoutes.routes,
        home: isLoggedIn?BottomNavigator():SplashScreen()
      ),
    );
  }
}
