import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
class SettingsService {
  static const String _themeModeKey = 'theme_mode';
  static const String _consentToDataCollectionKey = 'consent_to_data_collection';
  static const String _reminderCountKey = 'reminder_count';

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

  /// Loads the user's consent to data collection from local storage.
  Future<bool> consentToDataCollection() async {
    final consent = await sharedPreferences.getBool(_consentToDataCollectionKey);
    return consent ?? false;
  }

  /// Persists the user's consent to data collection to local storage.
  Future<void> updateConsentToDataCollection(bool consent) async {
    return sharedPreferences.setBool(_consentToDataCollectionKey, consent);
  }

  Future<int> reminderCount() async {
    final reminderCount = await sharedPreferences.getInt(_reminderCountKey);
    return reminderCount ?? 0;
  }

  Future<void> updateReminderCount(int count) async {
    return sharedPreferences.setInt(_reminderCountKey, count);
  }
}
