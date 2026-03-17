import 'package:azkar/business_logic/zikir_cubit/zikir_cubit.dart';
import 'package:azkar/data/repo/zikir_repository.dart';
import 'package:azkar/presentation/screens/main_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    // BlocProvider(
    // create: (context) => ZikirCubit(ZikirRepository()..getAllAzkar()),
    // child:
    AzkarApp(appRouter: AppRouter()),
    // ),
  );
}

class AzkarApp extends StatelessWidget {
  final AppRouter appRouter;

  const AzkarApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      // home: MainScaffold(),
    );
  }
}

class AppTheme {
  // static const Color primaryGreen = Color(0xFF2D5A27);
  // static const Color backgroundBeige = Color(0xFFF9F6EE);
  // static const Color accentGold = Color(0xFFD4AF37);
  // static const Color textDark = Color(0xFF1F1F1F);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // primaryColor: primaryGreen,
      // scaffoldBackgroundColor: backgroundBeige,

      // تطبيق خط Cairo كخط افتراضي لكل التطبيق
      textTheme:
          GoogleFonts.cairoTextTheme(
            const TextTheme(
              displayLarge: TextStyle(
                // color: textDark,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(
                // color: textDark,
                fontSize: 18,
              ),
              bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ).copyWith(
            // تخصيص خط Amiri للعناوين الكبيرة أو نصوص الأذكار
            displayMedium: GoogleFonts.cairo(
              textStyle: const TextStyle(
                // color: primaryGreen,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(

        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
      appBarTheme: AppBarTheme(
        // backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // backgroundColor: accentGold,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
