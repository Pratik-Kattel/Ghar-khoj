import 'package:flutter/cupertino.dart';
import 'package:frontend/features/Boarding/screens/boarding_screen.dart';
import 'package:frontend/features/auth/screens/forgot_password/forgot_password.dart';
import '../features/auth/screens/login/login_screen.dart';
import '../features/auth/screens/signup/register_screen.dart';

class AppRoutes{
  static const login='/login';
  static const boarding='/boarding';
  static const register='/register';
  static const forgotPassword='/forgotPassword';

static Map<String,WidgetBuilder> routes={
  boarding:(context)=> const BoardingScreen(),
  login:(context)=>  LoginScreen(),
  register:(context)=>RegisterScreen(),
  forgotPassword:(context)=>ForgotPassword(),
};
}