// import 'package:flutter/rendering.dart';

import 'package:azkar/app_router.dart';
import 'package:azkar/business_logic/prayer_time_cubit/prayer_time_cubit.dart';
import 'package:azkar/business_logic/theme_cubit/theme_cubit.dart';
import 'package:azkar/business_logic/zikir_by_category_cubit/zikir_by_category_cubit.dart';
import 'package:azkar/data/repo/prayer_repository.dart';
import 'package:azkar/data/repo/zikir_by_category.dart';
import 'package:azkar/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
Future<void> main() async {
  tz.initializeTimeZones();


  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isDark = prefs.getBool('is_dark_mode') ?? false;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  NotificationService notificationService = NotificationService();
  await notificationService.initNotification();
  // إعدادات أندرويد (أيقونة التطبيق)
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PrayerTimeCubit(PrayerRepository())..fetchPrayerTimes(),
        ),
        BlocProvider(create: (context) => ThemeCubit()), // تعريف الثيم هنا
        BlocProvider(
          create: (context) =>
              ZikirByCategoryCubit(ZikirByCategoryRepository())
                ..loadZikirByCategory(),
        ),
      ],
      child: AzkarApp(appRouter: AppRouter()),
    ),
  );
}

class AzkarApp extends StatelessWidget {
  final AppRouter appRouter;
  const AzkarApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, _) {
        return MaterialApp(
          themeMode: mode,
          // key: ValueKey(state),
          debugShowCheckedModeBanner: false,
          title: 'تطبيق الأذكار',
          locale: Locale('ar', 'DZ'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar', 'DZ')],
          // home: const MainScaffold(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // themeMode: state,
          // initialRoute: mainScaffold,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}

class AppTheme {
  static const Color primaryTeal = Colors.teal;
  static const Color lightBg = Color(0xFFF8FAFB);
  static const Color darkBg = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);

  // --- ثيم الوضع الداكن ---
  static ThemeData get darkTheme {
    return ThemeData(
      // 1. تفعيل Material3 للوضعين لضمان تناسق شكل الأزرار والـ Switch
      useMaterial3: true,
      brightness: Brightness.dark,

      // 2. استخدام colorScheme هو الطريقة الحديثة بدلاً من primaryColor المنفصل
      colorScheme: ColorScheme.dark(
        primary: primaryTeal,
        onPrimary: Colors.white,
        secondary: Colors.tealAccent,
        surface: darkCard,
        // background: darkBg,
      ),

      scaffoldBackgroundColor: darkBg,

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1F1F1F),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
      ),

      // 3. تصحيح تمرير الخط للـ TextTheme لضمان تطبيقه على كل النصوص
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),

      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white, // لون الأيقونات والنص في الأب بار
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        // اسمها CardTheme وليس CardThemeData
        color: darkCard,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),

      // 4. إضافة ثيم الـ Switch ليتناسب مع لون التيل (Teal)
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? primaryTeal : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaryTeal.withValues(alpha:0.5)
              : null,
        ),
      ),
    );
  }

  // --- ثيم الوضع الفاتح ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: const ColorScheme.light(
        primary: primaryTeal,
        onPrimary: Colors.white,
        secondary: primaryTeal,
        surface: Colors.white,
        // background: lightBg,
      ),

      scaffoldBackgroundColor: lightBg,

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryTeal,
        unselectedItemColor: Colors.grey,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
      ),

      textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme),

      appBarTheme: AppBarTheme(
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
