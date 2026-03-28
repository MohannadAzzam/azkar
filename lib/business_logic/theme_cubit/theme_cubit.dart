import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    // _loadTheme(); // استرجاع السمة عند إنشاء الكلاس
  }

  // مفتاح الحفظ
  // static const String _themeKey = 'isDarkMode';

  void toggleTheme()  {
    final newState = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    print('تغيير الثيم إلى: $newState');
    // final prefs = await SharedPreferences.getInstance();
    if (state != ThemeMode.light) {
      emit(ThemeMode.light);
      // await prefs.setBool(_themeKey, true); // حفظ الحالة (مظلم)
    } else {
      emit(ThemeMode.dark);
      // await prefs.setBool(_themeKey, false); // حفظ الحالة (فاتح)
    }
  }

  // void _loadTheme() async {
  // final prefs = await SharedPreferences.getInstance();
  // final isDark = prefs.getBool(_themeKey) ?? false; // الافتراضي فاتح
  // emit(isDark ? ThemeMode.dark : ThemeMode.light);
  // }
}
