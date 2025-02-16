import 'package:flutter/material.dart';
import 'color_schemes.g.dart';

abstract class AppTheme {
  static get light => ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: lightColorScheme.background,
      );
  static get dark => ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: darkColorScheme.background,
      );
}
