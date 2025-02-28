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
  String? label;
  Uint8List? iconBytes;

  FlutterApp({
    required this.packageName,
    this.label,
    this.iconBytes,
  });
}

@HostApi()
abstract class DetectorHostApi {
  List<FlutterApp> getApps();

  List<String> getPackages(String packageName);
}
