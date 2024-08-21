import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/config.dart' show AppRouter, AppTheme, SharedPref;
import 'services/service.dart' show LocalDatabaseService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initializing SQLite
    await LocalDatabaseService.db.database;

    // Initializing SharedPreferences
    await SharedPref.pref.initPrefer();
  } catch (e) {
    throw Exception(e);
  }

  return runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechTest App',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Spanish
        // Locale('en'), // English
      ],
      theme: AppTheme().lightTheme,
      initialRoute: AppRouter.initialRoute,
      routes: AppRouter.routes,
    );
  }
}
