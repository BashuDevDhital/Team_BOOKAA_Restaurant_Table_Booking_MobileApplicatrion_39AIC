import 'package:flutter/material.dart';
import 'view/Authenciation/Dashboard/auth_screens.dart';
import 'view/Authenciation/Widgets/app_theme.dart';

void main() {
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
