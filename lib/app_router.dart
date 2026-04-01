import 'package:azkar/business_logic/zikir_by_category_cubit/zikir_by_category_cubit.dart';
import 'package:azkar/data/repo/zikir_by_category.dart';
import 'package:azkar/presentation/screens/prayer_time_screen.dart';
import 'package:azkar/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic/zikir_cubit/zikir_cubit.dart';
import 'constants/strings.dart';
import 'data/models/zikir_category.dart';
import 'data/repo/zikir_repository.dart';
import 'presentation/screens/azkar_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/main_scaffold.dart';
import 'presentation/screens/tasbih_screen.dart';

class AppRouter {
  // static final _prayerRepository = PrayerRepository();
  // static final _prayerTimeCubit = PrayerTimeCubit(_prayerRepository)..fetchPrayerTimes();

  static Route? generateRoute(RouteSettings settings) {
    
  
    switch (settings.name) {
      case mainScaffold:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ZikirCubit(ZikirRepository())..loadAzkar(),
            child: MainScaffold(),
          ),
        );
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ZikirCubit(ZikirRepository())..loadAzkar(),
              ),
              BlocProvider(
                create: (context) =>
                    ZikirByCategoryCubit(ZikirByCategoryRepository())
                      ..loadZikirByCategory(),
              ),
            ],
            // استخدمنا Builder هنا للتأكد من تمرير Context نظيف ومشبع بالـ Providers
            child: Builder(builder: (context) => const HomeScreen()),
          ),
        );
      case azkarScreen:
        final azkar = settings.arguments as ZikirCategory;
        return MaterialPageRoute(
          builder: (_) => AzkarScreen(zikirCategory: azkar),
        );
      case tasbihScreen:
        return MaterialPageRoute(builder: (_) => TasbihScreen());
      case settingsScreen:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case prayerTimesScreen:
        return MaterialPageRoute(
          builder: (_) => const PrayerTimesScreen(),
        );
    }

    return null;
  }
}
