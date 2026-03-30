import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/build_categories_grid.dart';
import '../widgets/build_daily_quote.dart';
import '../widgets/build_quick_access.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تعريف ألوان ثابتة للتناسق
    final Color primaryColor = Colors.teal.shade700;
    final Color backgroundColor = Colors.grey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar محسن مع انحناءات وتصميم عصري
          SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            elevation: 0,
            stretch: true,
            backgroundColor: primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  getGreatings(),
                  key: ValueKey(getGreatings()),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 10)],
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [primaryColor, Colors.teal.shade400],
                  ),
                ),
                child: Icon(
                  Icons.mosque,
                  size: 100,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // آية اليوم بتصميم كرت مميز
                  buildDailyQuote(todayAya: todayAya()),

                  // قسم الإنجاز (تفعيل وإصلاح التصميم)
                  _buildProgressSection(primaryColor),

                  const SectionTitle(title: 'أذكار أساسية'),
                  // تأكد أن buildQuickAccess يعيد Row أو ListView.horizontal
                  SizedBox(height: 110, child: buildQuickAccess()),

                  const SectionTitle(title: 'التصنيفات'),
                  // تأكد من استخدام Padding داخل buildCategoriesGrid
                  buildCategoriesGrid(context),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // تصميم محسن لبطاقة الإنجاز
  Widget _buildProgressSection(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_graph, color: color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "إنجازك اليوم",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "قرأت 5 من أصل 12 ذكر",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: 0.4,
                strokeWidth: 6,
                backgroundColor: Colors.grey.shade100,
                color: Colors.orangeAccent,
              ),
              const Text(
                "40%",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
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
