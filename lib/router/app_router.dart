// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:mysql_flutter_crud/presentation/ui/home_screen.dart';
import '../screens/login_screen.dart';

class AppRouter {
  static const homeRoute = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
