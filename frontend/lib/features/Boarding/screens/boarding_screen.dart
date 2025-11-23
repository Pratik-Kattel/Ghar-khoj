import 'package:flutter/material.dart';
import 'package:frontend/features/Boarding/screens/boarding_screen_builder.dart';
import 'package:frontend/themes/app_themes.dart';
class BoardingScreen extends StatefulWidget{
  const BoardingScreen({super.key});

  @override
  BoardingScreenState createState()=> BoardingScreenState();
}

class BoardingScreenState extends State<BoardingScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:
          SafeArea(child:
              Expanded(child:
      PageView.builder(
                  controller: PageController(),
                  itemCount: BoardingScreenBuilder.pageviewBuilder.length,
                  itemBuilder:(context,index){
                    final items=BoardingScreenBuilder.pageviewBuilder[index];
                    return Column(
                      children: [
                        SizedBox(
                          height: 70,
                        ),
                        Image.asset(items['image']),
                        SizedBox(
                          height: 30,
                        ),
                        Text(items['title'],style: Theme.of(context).textTheme.titleLarge,),
                        SizedBox(
                          height: 50,
                        ),
                        Text(items['description'],style: Theme.of(context).textTheme.bodyLarge,)
                      ],

                    );
              }
              )
              )
          )
      );

  }
}