import 'package:flutter/material.dart';
import 'package:flutter_detect/src/flutter_apps/flutter_app_service.dart';

class FlutterAppController with ChangeNotifier {
  final FlutterAppService flutterAppService;

  AppScanResult? _result;

  FlutterAppController(this.flutterAppService);

  Future<AppScanResult?> getApps({bool forceRefresh = false}) async {
    if (_result != null && !forceRefresh) {
      return _result;
    }

    final result = await flutterAppService.getApps(forceRefresh: forceRefresh);
    if (result != null) {
      _result = result;
      flutterAppService.setApps(result.apps);
    }

    notifyListeners();

    return _result;
  }
}
