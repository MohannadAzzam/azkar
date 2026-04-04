import 'dart:math';
import 'package:azkar/services/notification_service.dart';
import 'package:flutter/material.dart';
import '../widgets/build_categories_grid.dart';
import '../widgets/build_daily_quote.dart';
import '../widgets/build_quick_access.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  buildDailyQuote(todayAya: todayAya()),

              
                  const SectionTitle(title: 'أذكار أساسية'),
                  SizedBox(height: 110, child: buildQuickAccess()),

                  const SectionTitle(title: 'التصنيفات'),
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

String getGreatings()  {
  var hour = DateTime.now().hour;
  if (hour < 12) {
 NotificationService().showInstantNotification('صباح الخير', 'لا تنسَ أذكار الصباح');

    return "صباح الخير، لا تنسَ أذكار الصباح";
  }
  if (hour < 17) {
    NotificationService().showInstantNotification('طاب يومك', 'طاب يومك بذكر الله');
    return "طاب يومك بذكر الله";
  }
  NotificationService().showInstantNotification('مساء الخير', 'هل قرأت أذكار المساء؟');
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
