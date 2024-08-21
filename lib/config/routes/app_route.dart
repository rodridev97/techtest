// Screens
import 'package:flutter/material.dart';

import '../../views/auth/auth.dart' show LoginScreen, RegisterScreen;
import '../../views/common/common.dart' show MainScreen;

class AppRouter {
  AppRouter._();

  static const String initialRoute = LoginScreen.routeName;
  static Map<String, Widget Function(BuildContext)> routes = {
    LoginScreen.routeName: (_) => const LoginScreen(),
    RegisterScreen.routeName: (_) => const RegisterScreen(),
    MainScreen.routeName: (_) => const MainScreen(),
  };
}
