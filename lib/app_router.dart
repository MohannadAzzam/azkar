import 'business_logic/zikir_cubit/zikir_cubit.dart';
import 'data/models/zikir_category.dart';
import 'data/repo/zikir_repository.dart';
import 'presentation/screens/azkar_screen.dart';
import 'presentation/screens/main_scaffold.dart';
import 'presentation/screens/tasbug_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/strings.dart';
import 'presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
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
          builder: (_) => BlocProvider(
            create: (context) => ZikirCubit(ZikirRepository())..loadAzkar(),
            child: HomeScreen(),
          ),
        );
      case azkarScreen:
        final azkar = settings.arguments as ZikirCategory;
        return MaterialPageRoute(
          builder: (_) => AzkarScreen(zikirCategory: azkar),
        );
      case tasbihScreen:
        return MaterialPageRoute(builder: (_) => TasbihScreen());
    }

    return null;
  }
}
