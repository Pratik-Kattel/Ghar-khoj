import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/themes/app_themes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  @override
  LoginScreenState createState()=> LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFF3E8FF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login your account",style: Theme.of(context).textTheme.titleLarge,),
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
