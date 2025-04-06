import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/detector.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/flutter/detector/flutter_detect/DetectorHostApi.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.flutter.detector.flutter_detect',
    ),
  ),
)
class Version {
  String dartVersion;
  String channel;

  Version({
    required this.dartVersion,
    required this.channel,
  });
}

class FlutterApp {
  String packageName;
  String flutterLibPath;
  String? appLibPath;
  Version? version;
  String? zipEntryPath;
  String? label;
  String? appVersion;
  Uint8List? iconBytes;

  FlutterApp({
    required this.packageName,
    required this.flutterLibPath,
    this.appLibPath,
    this.version,
    this.zipEntryPath,
    this.appVersion,
    this.label,
    this.iconBytes,
  });
}

@HostApi()
abstract class DetectorHostApi {
  @async
  List<FlutterApp> getApps();

  @async
  List<String> getPackages({required String appLibPath, String? zipEntryPath});
}

class ScanEvent {
  final int totalApps;
  final int currentCount;
  final FlutterApp? app;

  ScanEvent({
    required this.totalApps,
    required this.currentCount,
    this.app,
  });
}

@EventChannelApi()
abstract class ScanEventChannel {
  ScanEvent streamScanEvents();
}
