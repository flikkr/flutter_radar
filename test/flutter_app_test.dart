import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_detect/src/detector.g.dart';
import 'package:flutter_detect/src/flutter_apps/extension/flutter_app_ext.dart';

void main() {
  group('FlutterApp', () {
    test('encodeToString encodes FlutterApp correctly', () {
      // Create a test FlutterApp instance
      final app = FlutterApp(
        packageName: 'com.example.app',
        flutterLibPath: '/path/to/flutter/lib',
        appLibPath: '/path/to/app/lib',
        version: Version(
          dartVersion: '3.0.0',
          channel: 'stable',
        ),
        label: 'Example App',
        appVersion: '1.0.0',
      );

      // Encode the app to string
      final encoded = app.encodeToString();

      // Verify the encoded string is not empty
      expect(encoded, isNotEmpty);

      // Verify the encoded string contains the package name
      expect(encoded, contains('com.example.app'));

      // Verify the encoded string contains the version
      expect(encoded, contains('3.0.0'));
    });

    test('decodeFromString decodes FlutterApp correctly', () {
      // Create a test FlutterApp instance
      final originalApp = FlutterApp(
        packageName: 'com.example.app',
        flutterLibPath: '/path/to/flutter/lib',
        appLibPath: '/path/to/app/lib',
        version: Version(
          dartVersion: '3.0.0',
          channel: 'stable',
        ),
        label: 'Example App',
        appVersion: '1.0.0',
      );

      // Encode the app to string
      final encoded = originalApp.encodeToString();

      // Decode the string back to a FlutterApp
      final decodedApp = FlutterAppExtension.decodeFromString(encoded);

      // Verify the decoded app matches the original
      expect(decodedApp.packageName, equals(originalApp.packageName));
      expect(decodedApp.flutterLibPath, equals(originalApp.flutterLibPath));
      expect(decodedApp.appLibPath, equals(originalApp.appLibPath));
      expect(decodedApp.version?.dartVersion, equals(originalApp.version?.dartVersion));
      expect(decodedApp.version?.channel, equals(originalApp.version?.channel));
      expect(decodedApp.label, equals(originalApp.label));
      expect(decodedApp.appVersion, equals(originalApp.appVersion));
    });
  });
}
