// Autogenerated from Pigeon (v24.2.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

class Version {
  Version({
    required this.dartVersion,
    required this.channel,
  });

  String dartVersion;

  String channel;

  Object encode() {
    return <Object?>[
      dartVersion,
      channel,
    ];
  }

  static Version decode(Object result) {
    result as List<Object?>;
    return Version(
      dartVersion: result[0]! as String,
      channel: result[1]! as String,
    );
  }
}

class FlutterApp {
  FlutterApp({
    required this.packageName,
    required this.flutterLibPath,
    this.appLibPath,
    this.version,
    this.zipEntryPath,
    this.label,
    this.appVersion,
    this.iconBytes,
  });

  String packageName;

  String flutterLibPath;

  String? appLibPath;

  Version? version;

  String? zipEntryPath;

  String? label;

  String? appVersion;

  Uint8List? iconBytes;

  Object encode() {
    return <Object?>[
      packageName,
      flutterLibPath,
      appLibPath,
      version,
      zipEntryPath,
      label,
      appVersion,
      iconBytes,
    ];
  }

  static FlutterApp decode(Object result) {
    result as List<Object?>;
    return FlutterApp(
      packageName: result[0]! as String,
      flutterLibPath: result[1]! as String,
      appLibPath: result[2] as String?,
      version: result[3] as Version?,
      zipEntryPath: result[4] as String?,
      label: result[5] as String?,
      appVersion: result[6] as String?,
      iconBytes: result[7] as Uint8List?,
    );
  }
}

class ScanEvent {
  ScanEvent({
    required this.totalApps,
    required this.currentCount,
    this.app,
  });

  int totalApps;

  int currentCount;

  FlutterApp? app;

  Object encode() {
    return <Object?>[
      totalApps,
      currentCount,
      app,
    ];
  }

  static ScanEvent decode(Object result) {
    result as List<Object?>;
    return ScanEvent(
      totalApps: result[0]! as int,
      currentCount: result[1]! as int,
      app: result[2] as FlutterApp?,
    );
  }
}


class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    }    else if (value is Version) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    }    else if (value is FlutterApp) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    }    else if (value is ScanEvent) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129: 
        return Version.decode(readValue(buffer)!);
      case 130: 
        return FlutterApp.decode(readValue(buffer)!);
      case 131: 
        return ScanEvent.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

const StandardMethodCodec pigeonMethodCodec = StandardMethodCodec(_PigeonCodec());

class DetectorHostApi {
  /// Constructor for [DetectorHostApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  DetectorHostApi({BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : pigeonVar_binaryMessenger = binaryMessenger,
        pigeonVar_messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
  final BinaryMessenger? pigeonVar_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  final String pigeonVar_messageChannelSuffix;

  Future<List<FlutterApp>> getApps() async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.flutter_radar.DetectorHostApi.getApps$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(null);
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as List<Object?>?)!.cast<FlutterApp>();
    }
  }

  Future<List<String>> getPackages({required String appLibPath, String? zipEntryPath}) async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.flutter_radar.DetectorHostApi.getPackages$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(<Object?>[appLibPath, zipEntryPath]);
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as List<Object?>?)!.cast<String>();
    }
  }
}

Stream<ScanEvent> streamScanEvents( {String instanceName = ''}) {
  if (instanceName.isNotEmpty) {
    instanceName = '.$instanceName';
  }
  final EventChannel streamScanEventsChannel =
      EventChannel('dev.flutter.pigeon.flutter_radar.ScanEventChannel.streamScanEvents$instanceName', pigeonMethodCodec);
  return streamScanEventsChannel.receiveBroadcastStream().map((dynamic event) {
    return event as ScanEvent;
  });
}
    
