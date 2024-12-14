import 'package:flutter/material.dart';

ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  primary: const Color.fromARGB(255, 32, 94, 180),
  background: Colors.white,
  onBackground: Colors.black,
  onPrimary:  Colors.blue,
  secondary: Colors.grey,
);

ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  primary: const Color.fromARGB(255, 32, 94, 180),
  background: Colors.black,
  onBackground: Colors.white,
  onPrimary:  Colors.blue,
  secondary: Colors.grey,
);

class AppTheme {
  static final light = ThemeData.from(colorScheme: lightColorScheme);
  static final dark = ThemeData.from(colorScheme: darkColorScheme);
}
