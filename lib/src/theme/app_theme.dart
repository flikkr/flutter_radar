import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF1A3557); // Deep blue

  static ThemeData light() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.light,
        ),
      );

  static ThemeData dark() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.dark,
        ),
      );
}
