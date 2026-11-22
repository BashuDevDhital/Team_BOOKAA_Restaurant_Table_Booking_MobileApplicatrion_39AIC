import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'auth_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BooKaaApp());
}

class BooKaaApp extends StatelessWidget {
  const BooKaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boo-KAA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
