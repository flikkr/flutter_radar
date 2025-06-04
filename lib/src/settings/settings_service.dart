import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
class SettingsService {
  static const String _themeModeKey = 'theme_mode';

  final SharedPreferencesAsync sharedPreferences;

  SettingsService(this.sharedPreferences);

  /// Loads the user's preferred ThemeMode from local storage.
  Future<ThemeMode> themeMode() async {
    final themeMode = await sharedPreferences.getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (e) => e.name == themeMode,
      orElse: () => ThemeMode.system,
    );
  }

  /// Persists the user's preferred ThemeMode to local storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    return sharedPreferences.setString(_themeModeKey, theme.name);
  }
}
