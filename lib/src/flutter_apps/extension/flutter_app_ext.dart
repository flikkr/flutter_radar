import 'dart:typed_data';
import 'package:flutter_detect/src/detector.g.dart';

extension FlutterAppExtension on FlutterApp {
  String encodeToString() {
    final bytes = DetectorHostApi.pigeonChannelCodec.encodeMessage(encode());
    final list = bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    return String.fromCharCodes(list);
  }

  static FlutterApp decodeFromString(String encoded) {
    final bytes = Uint8List.fromList(encoded.codeUnits);
    final byteData = ByteData.view(bytes.buffer, bytes.offsetInBytes, bytes.lengthInBytes);
    final decoded = DetectorHostApi.pigeonChannelCodec.decodeMessage(byteData);
    return FlutterApp.decode(decoded!);
  }
}
