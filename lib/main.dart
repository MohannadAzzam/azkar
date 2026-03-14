import 'package:azkar/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AzkarApp(appRouter: AppRouter()));
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
