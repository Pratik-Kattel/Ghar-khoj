import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/Boarding/screens/boarding_screen.dart';
import 'package:frontend/main.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/constants/assets_path.dart';
import 'package:frontend/features/Boarding/screens/boarding_screen_builder.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  @override
  Widget build (BuildContext context){
    String path=BoardingScreenData.splashAnimation;
    return AnimatedSplashScreen(splash: 
        Column(
          children: [
            Expanded(child:
            Center(
              child:
              SizedBox(
            height: 600,
              width: 600,
              child:
              LottieBuilder.asset(path),
            )
            )
            ),
          ],
        )
        , nextScreen:const  BoardingScreen(),
      splashIconSize: 750,
      duration: 3250,

      backgroundColor: Color(0xFFF3E8FF),
    );
  }
}
