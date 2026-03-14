import 'package:azkar/app_router.dart';
import 'package:azkar/business_logic/cubit/zikir_cubit.dart';
import 'package:azkar/data/repo/zikir_repository.dart';
import 'package:azkar/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ZikirCubit(ZikirRepository())..loadAzkar(),
      child: AzkarApp(appRouter: AppRouter()),
    ),
  );
}

class AzkarApp extends StatelessWidget {
  final AppRouter appRouter;

  const AzkarApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
