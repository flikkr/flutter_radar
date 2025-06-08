import 'package:flutter/material.dart';
import 'package:flutter_radar/src/detector.g.dart';
import 'package:flutter_radar/src/flutter_apps/flutter_app_controller.dart';
import 'package:flutter_radar/src/flutter_apps/flutter_app_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flutterAppController = FlutterAppController(
    FlutterAppService(sharedPreferences: SharedPreferencesAsync(), detectorHostApi: DetectorHostApi()),
  );
  final settingsController = SettingsController(SettingsService(SharedPreferencesAsync()));
  await settingsController.loadSettings();
  MobileAds.instance.initialize();

  runApp(MyApp(settingsController: settingsController, flutterAppController: flutterAppController));
}
