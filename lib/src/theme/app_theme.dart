import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() => ThemeData.light().copyWith(
        progressIndicatorTheme: ProgressIndicatorThemeData(
          year2023: false,
        ),
      );

  static ThemeData dark() => ThemeData.dark().copyWith(
        progressIndicatorTheme: ProgressIndicatorThemeData(
          year2023: false,
        ),
      );
}
