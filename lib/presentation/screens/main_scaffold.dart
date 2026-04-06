import 'prayer_time_screen.dart';
import 'settings_screen.dart';

import '../../constants/strings.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text("صفحة القبلة معطلة")),
    const PrayerTimesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // نترك الـ floatingActionButton فارغاً هنا لأننا سنضعه يدوياً بالأسفل
      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none, // للسماح للزر بالخروج عن حدود البار قليلاً
        children: [
          // 1. البار السفلي الطبيعي
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 1) return; // تعطيل القبلة
              setState(() => _selectedIndex = index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'الرئيسية',
              ),

              // أيقونة القبلة (نجعلها شفافة تماماً ليظهر الزر مكانها)
              const BottomNavigationBarItem(
                icon: Opacity(opacity: 0, child: Icon(Icons.explore)),
                label: '',
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.mosque),
                label: 'المواقيت',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'الإعدادات',
              ),
            ],
          ),

          // 2. الزر العائم اليدوي (Positioned)
          Positioned(
            bottom:
                MediaQuery.of(context).size.height *
                0.059, // ارتفاع الزر عن أسفل الشاشة
            right:
                MediaQuery.of(context).size.width *
                0.30, // تحريكه ليقف فوق الخيار الثاني
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, tasbihScreen),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.touch_app,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
