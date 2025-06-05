import 'package:flutter/material.dart';
import 'package:flutter_radar/src/flutter_apps/flutter_app_service.dart';

class FlutterAppController with ChangeNotifier {
  final FlutterAppService flutterAppService;

  AppScanResult? _result;

  FlutterAppController(this.flutterAppService);

  Stream<AppScanResult?> appScanStream({bool forceRefresh = false}) {
    return flutterAppService.appScanStream(forceRefresh: forceRefresh).asyncMap((result) async {
      if (result.isScanComplete) {
        await flutterAppService.cacheScanResult(result);
      }
      return result;
    });
  }

  // Future<AppScanResult?> getApps({bool forceRefresh = false}) async {
  //   if (_result != null && !forceRefresh) {
  //     return _result;
  //   }

  //   final result = await flutterAppService.getApps(forceRefresh: forceRefresh);
  //   if (result != null) {
  //     _result = result;
  //     flutterAppService._setApps(result.apps);
  //   }

  //   notifyListeners();

  //   return _result;
  // }
}
