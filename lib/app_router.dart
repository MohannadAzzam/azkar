import 'package:azkar/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        MaterialPageRoute(builder: (_) => HomeScreen());
    }
    return null;
  }
}
