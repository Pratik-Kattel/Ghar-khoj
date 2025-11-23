import 'package:flutter/cupertino.dart';
import 'package:frontend/features/Boarding/screens/boarding_screen.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';

class AppRoutes{
  static const login='/login';
  static const boarding='/boarding';

static Map<String,WidgetBuilder> routes={
  boarding:(context)=> const BoardingScreen(),
  login:(context)=> const LoginScreen(),
};
}