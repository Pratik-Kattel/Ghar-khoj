import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSwitchCubit extends Cubit<bool>{
  ThemeSwitchCubit():super(false){
    _loadTheme();
  }
  
  Future<void> _loadTheme() async{
    final prefs=await SharedPreferences.getInstance();
    emit(prefs.getBool('isDarkMode') ?? false);
  }

  Future<void> toggleTheme() async{
    final prefs=await SharedPreferences.getInstance();
    final newValue=!state;
    await prefs.setBool('isDarkMode', newValue);
    emit(newValue);
  }
}