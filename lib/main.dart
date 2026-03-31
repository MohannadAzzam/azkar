// import 'package:flutter/rendering.dart';

import 'package:azkar/app_router.dart';
import 'package:azkar/business_logic/theme_cubit/theme_cubit.dart';
import 'package:azkar/business_logic/zikir_by_category_cubit/zikir_by_category_cubit.dart';
import 'package:azkar/data/repo/zikir_by_category.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // await initializeDateFormatting('ar', "");
  // debugRepaintRainbowEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();
// إعدادات أندرويد (أيقونة التطبيق)
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);
  runApp(
    MultiBlocProvider(
      providers: [
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
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return MaterialApp(
          key: ValueKey(state),
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
          themeMode: state,
          // initialRoute: mainScaffold,
          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}

class AppTheme {
  // ألوان ثابتة للسهولة
  static const Color primaryTeal = Colors.teal;
  static const Color lightBg = Color(0xFFF8FAFB);
  static const Color darkBg = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);

  // --- ثيم الوضع الداكن ---
  static ThemeData get darkTheme {
    return ThemeData(
      // useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryTeal,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: primaryTeal,
        secondary: Colors.tealAccent,
        surface: darkCard,
      ),
      // إعدادات البار السفلي للوضع الداكن
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1F1F1F), // رمادي غامق جداً وليس أسود
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),

      // إعدادات الزر العائم للوضع الداكن
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1F1F1F),
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  // --- ثيم الوضع الفاتح ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryTeal,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        primary: primaryTeal,
        secondary: primaryTeal,
        surface: Colors.white,
      ),
      // إعدادات البار السفلي للوضع الفاتح
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),

      // إعدادات الزر العائم للوضع الفاتح
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.teal,
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
