import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/features/splash/screens/splash_screen.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/repository/auth_repository.dart';
import 'package:frontend/features/auth/bloc/login_bloc.dart';

void main() {
  final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
  final authRepo = AuthRepository(apiClient: apiClient);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginBloc(repository: authRepo),
        )
      ],
      child: const myApp(),
    ),
  );
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