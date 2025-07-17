import 'package:flutter/material.dart';
import 'package:yoweme/core/utils/theme/theme.dart';
import 'package:yoweme/screens/home_screen.dart';

void main() {
  runApp(const YOweMeApp());
}

class YOweMeApp extends StatelessWidget {
  const YOweMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOweMe',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Allows system to switch between light/dark
      home: const HomeScreen(),
    );
  }
}
