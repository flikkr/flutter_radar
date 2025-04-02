import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detect/src/detector.g.dart';
import 'package:flutter_detect/src/flutter_apps/extension/flutter_app_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScanResult {
  final List<FlutterApp> apps;
  final int lastScanTime;

  AppScanResult({
    required this.apps,
    required this.lastScanTime,
  });
}

class FlutterAppService {
  static const String _appsKey = 'installed_apps';
  static const String _lastScanTimeKey = 'last_scan_time';
  static const String _scanExecutionTimeKey = 'scan_execution_time';

  final SharedPreferencesAsync sharedPreferences;
  final DetectorHostApi detectorHostApi;

  FlutterAppService({
    required this.sharedPreferences,
    required this.detectorHostApi,
  });

  Future<AppScanResult?> getApps({bool forceRefresh = false}) async {
    AppScanResult? result;
    try {
      // get installed apps from shared preferences
      if (forceRefresh) {
        await _clearApps();
      } else {
        final encoded = await sharedPreferences.getStringList(_appsKey);
        final apps = encoded?.map((e) => FlutterAppExtension.decodeFromString(e)).toList() ?? [];
        result = AppScanResult(apps: apps, lastScanTime: await _getLastScanTime());
      }

      // collect installed apps from native layer
      if (result == null) {
        final lastScanTime = DateTime.now().millisecondsSinceEpoch;
        await _setLastScanTime(lastScanTime);
        result = AppScanResult(apps: await _scanApps(), lastScanTime: lastScanTime);
      }
    } on FormatException catch (e) {
      debugPrint('Error decoding apps: $e');
    }

    return result;
  }

  Future<void> setApps(List<FlutterApp> apps) async {
    final encoded = apps.map((app) => app.encodeToString()).toList();
    return sharedPreferences.setStringList(_appsKey, encoded);
  }

  Future<void> _clearApps() async {
    return sharedPreferences.remove(_appsKey);
  }

  Future<List<FlutterApp>> _scanApps() async {
    // Get the token from the root isolate
    final rootIsolateToken = RootIsolateToken.instance!;

    return Isolate.run<List<FlutterApp>>(() async {
      // Initialize the binary messenger for the background isolate
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
      final detectorHostApi = DetectorHostApi();
      return await detectorHostApi.getApps();
    });
  }

  Future<int> _getLastScanTime() async {
    final value = await sharedPreferences.getInt(_lastScanTimeKey);
    return value ?? 0;
  }

  Future<void> _setLastScanTime(int lastScanTime) async {
    return sharedPreferences.setInt(_lastScanTimeKey, lastScanTime);
  }

  Future<int> _getScanExecutionTime() async {
    final value = await sharedPreferences.getInt(_scanExecutionTimeKey);
    return value ?? 0;
  }

  Future<void> _setScanExecutionTime(int scanExecutionTime) async {
    return sharedPreferences.setInt(_scanExecutionTimeKey, scanExecutionTime);
  }
}
