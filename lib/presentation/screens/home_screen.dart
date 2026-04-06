import 'dart:math';
import '../../services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // مهم للفحص
import '../widgets/build_categories_grid.dart';
import '../widgets/build_daily_quote.dart';
import '../widgets/build_quick_access.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _service = NotificationService();
  late String _greetingMessage;

  @override
  void initState() {
    super.initState();
    _greetingMessage = getGreetingsText();
    _sendWelcomeNotification();
  }

  // ميثود إرسال الإشعار مع فحص حالة الإعدادات
  void _sendWelcomeNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isEnabled = prefs.getBool('notifications_enabled') ?? true;

    // إذا عطل المستخدم الإشعارات، نخرج ولا نرسل شيئاً
    if (!isEnabled) return;

    var hour = DateTime.now().hour;
    if (hour < 12) {
      await _service.showInstantNotification(
        'صباح الخير',
        'لا تنسَ أذكار الصباح',
      );
    } else if (hour < 17) {
      await _service.showInstantNotification('طاب يومك', 'طاب يومك بذكر الله');
    } else {
      await _service.showInstantNotification(
        'مساء الخير',
        'هل قرأت أذكار المساء؟',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      // استخدام خلفية الثيم
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            pinned: true,
            backgroundColor: primaryColor,
            // تغيير لون النص والأيقونات تلقائياً بناءً على الثيم
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                _greetingMessage,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // نثبت الأبيض هنا لأن الهيدر Teal دائماً
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor,
                      isDark ? Colors.teal.shade900 : Colors.teal.shade400,
                    ],
                  ),
                ),
                child: Icon(
                  Icons.mosque,
                  size: 100,
                  color: Colors.white.withValues(alpha:0.1),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  // الآية اليومية
                  buildDailyQuote(todayAya: todayAya()),

                  const SectionTitle(title: 'أذكار أساسية'),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: buildQuickAccess(),
                  ),

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

// دالة منفصلة للنص
String getGreetingsText() {
  var hour = DateTime.now().hour;
  if (hour < 12) return "صباح الخير، لا تنسَ أذكار الصباح";
  if (hour < 17) return "طاب يومك بذكر الله";
  return "مساء الخير، هل قرأت أذكار المساء؟";
}

// تعديل SectionTitle ليدعم الثيم
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary, // لون التيل من الثيم
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: theme.textTheme.titleLarge?.color, // لون النص المناسب
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// دالة الآيات تبقى كما هي
List<String> ayat = [
  "فَاذْكُرُونِي أَذْكُرْكُمْ",
  "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
  "وَاسْتَغْفِرُوا رَبَّكُمْ ثُمَّ تُوبُوا إِلَيْهِ",
];

String todayAya() {
  Random random = Random();
  var selectedAya = random.nextInt(ayat.length);
  return ayat[selectedAya];
}
