import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/Boarding/screens/boarding_screen.dart';
import 'package:frontend/features/splash/screens/splash_screen.dart';

void main(){
  runApp(myApp());
}

class myApp extends StatelessWidget{
  const myApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}