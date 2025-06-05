import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radar/src/detector.g.dart';
import 'package:flutter_radar/src/flutter_apps/extension/flutter_app_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScanResult {
  final List<FlutterApp> apps;
  final int? totalApps;
  final int? currentCount;
  final int lastScanTime;

  AppScanResult({required this.apps, this.totalApps, this.currentCount, required this.lastScanTime});

  double get progress => currentCount != null ? currentCount! / totalApps! : 0;

  bool get isScanComplete => currentCount == totalApps;
}

class FlutterAppService {
  static const String _appsKey = 'installed_apps';
  static const String _totalAppsKey = 'total_apps';
  static const String _lastScanTimeKey = 'last_scan_time';
  static const String _scanExecutionTimeKey = 'scan_execution_time';

  final SharedPreferencesAsync sharedPreferences;
  final DetectorHostApi detectorHostApi;
  final List<FlutterApp> _apps = [];

  FlutterAppService({required this.sharedPreferences, required this.detectorHostApi});

  Stream<AppScanResult> appScanStream({bool forceRefresh = false}) async* {
    // First check if we have apps in shared preferences
    _apps.clear();

    if (forceRefresh) {
      await _clearCache();
    } else {
      final encoded = await sharedPreferences.getStringList(_appsKey);
      if (encoded != null && encoded.isNotEmpty) {
        final apps = encoded.map((e) => FlutterAppExtension.decodeFromString(e)).toList();
        final totalApps = await _getTotalAppCount();
        // Return a single event with all apps and matching counts
        yield AppScanResult(
          apps: apps,
          lastScanTime: await _getLastScanTime(),
          totalApps: totalApps,
          currentCount: totalApps,
        );
        return;
      }
    }

    // If no apps in shared preferences, run the scan stream
    yield* streamScanEvents().map((scanEvent) {
      if (scanEvent.app != null) {
        _apps.add(scanEvent.app!);
      }
      return AppScanResult(
        apps: _apps,
        lastScanTime: DateTime.now().millisecondsSinceEpoch,
        totalApps: scanEvent.totalApps,
        currentCount: scanEvent.currentCount,
      );
    });
  }

  Future<AppScanResult?> getApps({bool forceRefresh = false}) async {
    AppScanResult? result;
    try {
      // get installed apps from shared preferences
      if (forceRefresh) {
        await _clearCache();
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

  Future<void> cacheScanResult(AppScanResult result) async {
    await _setApps(result.apps);
    await _setTotalAppCount(result.totalApps ?? 0);
    await _setLastScanTime(result.lastScanTime);
  }

  Future<void> _setApps(List<FlutterApp> apps) async {
    final encoded = apps.map((app) => app.encodeToString()).toList();
    return sharedPreferences.setStringList(_appsKey, encoded);
  }

  Future<void> _clearCache() async {
    await sharedPreferences.remove(_appsKey);
    await sharedPreferences.remove(_totalAppsKey);
    await sharedPreferences.remove(_lastScanTimeKey);
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

  Future<int> _getTotalAppCount() async {
    final value = await sharedPreferences.getInt(_totalAppsKey);
    return value ?? 0;
  }

  Future<void> _setTotalAppCount(int totalApps) async {
    return sharedPreferences.setInt(_totalAppsKey, totalApps);
  }

  // Future<int> _getScanExecutionTime() async {
  //   final value = await sharedPreferences.getInt(_scanExecutionTimeKey);
  //   return value ?? 0;
  // }

  // Future<void> _setScanExecutionTime(int scanExecutionTime) async {
  //   return sharedPreferences.setInt(_scanExecutionTimeKey, scanExecutionTime);
  // }
}
