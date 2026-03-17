import 'dart:math';

import 'package:azkar/constants/strings.dart';
import 'package:azkar/data/models/zikir_category.dart';

import '../../business_logic/zikir_cubit/zikir_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  String getGreatings() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return "صباح الخير، لا تنسَ أذكار الصباح";
    }
    if (hour < 17) {
      return "طاب يومك بذكر الله";
    }
    return "مساء الخير، هل قرأت أذكار المساء؟";
  }

  List<String> ayat = [
    "فَاذْكُرُونِي أَذْكُرْكُمْ",
    "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
    "وَاسْتَغْفِرُوا رَبَّكُمْ ثُمَّ تُوبُوا إِلَيْهِ",
  ];

  String todayAya() {
    Random random = Random();
    var selectedAya = random.nextInt(ayat.length);
    return ayat[selectedAya];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        // AppBar جذاب مع تحية متغيرة
        SliverAppBar(
          expandedHeight: 120.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "${getGreatings()}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.teal,
        ),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. البطاقة المتغيرة (آية اليوم)
              _buildDailyQuote(),

              // 6. لمسة تفاعلية (Progress Indicator)
              _buildProgressSection(),

              const SectionTitle(title: 'أذكار أساسية'),
              _buildQuickAccess(),

              // _buildQuickAccess(),
              const SectionTitle(title: 'التصنيفات'),
              _buildCategoriesGrid(),

              const SizedBox(height: 80), // مساحة للـ FAB
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyQuote() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade700],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white70, size: 24),
          const SizedBox(height: 10),
          Text(
            '${todayAya()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              // fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
            ),
          ),
          // const Text(
          //   "سورة الرعد",
          //   style: const TextStyle(color: Colors.white60, fontSize: 12),
          // ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "إنجازك اليوم",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "قرأت 5 من أصل 12 ذكر",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          CircularProgressIndicator(
            value: 0.5,
            strokeWidth: 5,
            backgroundColor: Colors.grey.shade200,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  // ... (تكملة الـ Grid والـ QuickAccess كما في المثال السابق)
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ويدجت الوصول السريع
Widget _buildQuickAccess() {
  return BlocBuilder<ZikirCubit, ZikirState>(
    builder: (context, state) {
      if (state is ZikirLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is ZikirLoaded) {
        return SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: state.azkarList.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              if (state.azkarList[index].category == "أذكار الصباح") {
                return _quickCard(
                  state.azkarList[index].category,
                  Icons.wb_sunny,
                  Colors.orange,
                  context,
                  zikirCategory: state.azkarList[index],
                );
              }
              if (state.azkarList[index].category == "أذكار المساء") {
                return _quickCard(
                  state.azkarList[index].category,
                  Icons.nightlight_round,
                  Colors.indigo,
                  context,
                  zikirCategory: state.azkarList[index],
                );
              }
              if (state.azkarList[index].category == "أذكار النوم") {
                return _quickCard(
                  state.azkarList[index].category,
                  Icons.bedtime,
                  Colors.purple,
                  context,
                  zikirCategory: state.azkarList[index],
                );
              } else {
                return Container(color: Colors.red, height: 20, width: 20);
              }
            },
          ),
        );
      } else {
        return Center(child: Text('حدث خطأ أثناء تحميل الأذكار'));
      }
    },
  );
}

Widget _quickCard(
  String title,
  IconData icon,
  Color color,
  BuildContext context, {
  ZikirCategory? zikirCategory,
}) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, azkarScreen, arguments: zikirCategory);
    },
    child: Container(
      width: 140,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

// شبكة التصنيفات
Widget _buildCategoriesGrid() {
  final categories = [
    'أدعية نبوية',
    'أذكار الصلاة',
    'أذكار السفر',
    'أذكار الطعام',
  ];
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    ),
    itemCount: categories.length,
    itemBuilder: (context, index) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(categories[index], style: const TextStyle(fontSize: 16)),
        ),
      );
    },
  );
}

//  BlocBuilder<ZikirCubit, ZikirState>(
//   builder: (context, state) {
//     if (state is ZikirLoading) {
//       return Center(child: CircularProgressIndicator());
//     } else if (state is ZikirLoaded) {
//       return ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: state.azkarList.length,
//         itemBuilder: (context, index) {
//           final category = state.azkarList[index];
//           return Card(
//             elevation: 4,
//             margin: EdgeInsets.only(bottom: 12),

//             child: ListTile(
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 10,
//               ),

//               title: Text(
//                 textAlign: TextAlign.end,

//                 category.category,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               leading: Icon(Icons.arrow_back_ios, size: 18),
//               onTap: () {
//                 Navigator.pushNamed(context, azkar, arguments: category);
//               },
//             ),
//           );
//         },
//       );
//     } else {
//       return Center(child: Text('حدث خطأ أثناء تحميل الأذكار'));
//     }
//   },
// ),

Widget quickCard(String title, IconData icon, Color color) {
  return Container(
    width: 140,
    margin: EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 35),
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
