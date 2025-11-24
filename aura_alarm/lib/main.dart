import 'package:aura_alarm/home_screen.dart';
import 'package:aura_alarm/theme_data.dart';
import 'package:aura_alarm/world_clock_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const WorldClockApp());
}

class WorldClockApp extends StatelessWidget {
  const WorldClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Clock Mockup',
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}
