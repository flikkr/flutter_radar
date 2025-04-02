import 'package:flutter/material.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  final SettingsService _settingsService;

  late ThemeMode _themeMode;
  late bool _consentToDataCollection;
  late int _reminderCount;

  SettingsController(this._settingsService);

  ThemeMode get themeMode => _themeMode;
  bool get consentToDataCollection => _consentToDataCollection;
  int get reminderCount => _reminderCount;

  /// Load the user's settings from the SettingsService.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _consentToDataCollection = await _settingsService.consentToDataCollection();
    _reminderCount = await _settingsService.reminderCount();
    
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    notifyListeners();

    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateConsentToDataCollection(bool? newConsentToDataCollection) async {
    if (newConsentToDataCollection == null) return;

    _consentToDataCollection = newConsentToDataCollection;

    notifyListeners();

    await _settingsService.updateConsentToDataCollection(newConsentToDataCollection);
  }

  Future<void> incrementReminderCount() async {
    final newReminderCount = await _settingsService.reminderCount();

    _reminderCount = newReminderCount + 1;

    notifyListeners();

    await _settingsService.updateReminderCount(_reminderCount);
  }
}
