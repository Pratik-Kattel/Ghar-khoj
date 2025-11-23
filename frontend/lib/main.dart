import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/features/splash/screens/splash_screen.dart';
import 'package:frontend/themes/app_themes.dart';

void main(){
  runApp(myApp());
}

class myApp extends StatelessWidget{
  const myApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.purpleTheme,
      routes: AppRoutes.routes,
      home: SplashScreen()
    );
  }
}