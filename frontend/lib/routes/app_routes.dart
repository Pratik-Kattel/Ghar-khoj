import 'package:flutter/cupertino.dart';
import 'package:frontend/features/Boarding/screens/boarding_screen.dart';
import 'package:frontend/features/Bottom_Navigator/Bottom_Navigator.dart';
import 'package:frontend/features/HomeScreen/Screen/HomeScreen.dart';
import 'package:frontend/features/Settings/Screen/edit_profile_page.dart';
import 'package:frontend/features/auth/screens/forgot_password/validate_email_screen.dart';
import '../features/auth/screens/login/login_screen.dart';
import '../features/auth/screens/signup/register_screen.dart';

class AppRoutes{
  static const login='/login';
  static const boarding='/boarding';
  static const register='/register';
  static const forgotPassword='/forgotPassword';
  static const homeScreen='/homeScreen';
  static const editProfile='/editProfile';
  static const bottomNavigator='/bottomNavigator';


static Map<String,WidgetBuilder> routes={
  boarding:(context)=> const BoardingScreen(),
  login:(context)=>  LoginScreen(),
  register:(context)=>RegisterScreen(),
  forgotPassword:(context)=>ForgotPassword(),
  homeScreen:(context)=>Homescreen(),
  editProfile:(context)=>EditProfilePage(),
  bottomNavigator:(context)=>BottomNavigator()
};
}