import 'dart:math';

import '../widgets/build_categories_grid.dart';
import '../widgets/build_daily_quote.dart';
import '../widgets/build_quick_access.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 120.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              getGreatings(),
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
              buildDailyQuote(todayAya: todayAya()),

              // 6. لمسة تفاعلية (Progress Indicator)
              // _buildProgressSection(),

              const SectionTitle(title: 'أذكار أساسية'),
              buildQuickAccess(),

              // _buildQuickAccess(),
              const SectionTitle(title: 'التصنيفات'),
              buildCategoriesGrid(context),

              const SizedBox(height: 80), // مساحة للـ FAB
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildProgressSection() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     padding: const EdgeInsets.all(15),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: Row(
  //       children: [
  //         const Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "إنجازك اليوم",
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 5),
  //               Text(
  //                 "قرأت 5 من أصل 12 ذكر",
  //                 style: TextStyle(fontSize: 12, color: Colors.grey),
  //               ),
  //             ],
  //           ),
  //         ),
  //         CircularProgressIndicator(
  //           value: 0.5,
  //           strokeWidth: 5,
  //           backgroundColor: Colors.grey.shade200,
  //           color: Colors.orange,
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

// Widget quickCard(String title, IconData icon, Color color) {
//   return Container(
//     width: 140,
//     margin: EdgeInsets.all(4),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, color: color, size: 35),
//         SizedBox(height: 8),
//         Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//       ],
//     ),
//   );
// }

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
