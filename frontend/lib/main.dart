import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/features/auth/Repository/forgot_password/validate_email_repo.dart';
import 'package:frontend/features/auth/Repository/signup/signup_repo.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:frontend/features/auth/bloc/signup/signup_bloc.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/features/splash/screens/splash_screen.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './features/auth/bloc/login/login_bloc.dart';
import './features/auth/Repository/login/login_repo.dart';

void main() {
  final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
  final loginRepo = LoginRepository(apiClient: apiClient);
  final signUpRepo=SignupRepository(apiClient: apiClient);
  final validateEmailRepository=ValidateEmailRepository(apiClient: apiClient);


  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(repository: loginRepo)),
        BlocProvider(create: (_)=>SignupBloc(signupRepository: signUpRepo)),
        BlocProvider(create: (_)=>ForgotPasswordBloc(validateEmailRepository: validateEmailRepository))
      ],
      child: const myApp(),
    ),
  );
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(390, 844),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context,child)=>MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.purpleTheme,
      routes: AppRoutes.routes,
      home: SplashScreen(),
    )
    );
  }

}
