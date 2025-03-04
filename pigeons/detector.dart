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
class FlutterApp {
  String packageName;
  String flutterLibPath;
  String appLibPath;
  String dartVersion;
  String? zipEntryPath;
  String? label;
  String? appVersion;
  Uint8List? iconBytes;

  FlutterApp({
    required this.packageName,
    required this.flutterLibPath,
    required this.appLibPath,
    required this.dartVersion,
    this.zipEntryPath,
    this.appVersion,
    this.label,
    this.iconBytes,
  });
}

@HostApi()
abstract class DetectorHostApi {
  List<FlutterApp> getApps();

  List<String> getPackages({required String appLibPath, String? zipEntryPath});
}
