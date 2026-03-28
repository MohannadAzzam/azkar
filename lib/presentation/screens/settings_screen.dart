import 'package:azkar/business_logic/theme_cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام watch سيجعل الشاشة تعيد بناء نفسها عند تغيير الثيم
    final themeMode = context.watch<ThemeCubit>().state;
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        // أفضل من Container لسهولة إضافة إعدادات مستقبلاً
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: Colors.teal,
              ),
              title: const Text("الوضع الداكن", style: TextStyle(fontSize: 18)),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                activeThumbColor: Colors.teal,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
