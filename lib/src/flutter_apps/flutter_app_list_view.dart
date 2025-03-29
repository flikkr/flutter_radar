import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show BackgroundIsolateBinaryMessenger, RootIsolateToken;
import 'package:flutter_detect/src/detector.g.dart';
import 'package:flutter_detect/src/flutter_apps/flutter_app_list_content.dart';
import 'package:flutter_detect/src/settings/settings_view.dart';


class FlutterAppListView extends StatefulWidget {
  static const routeName = '/';

  const FlutterAppListView({super.key});

  @override
  State<FlutterAppListView> createState() => _FlutterAppListViewState();
}

class _FlutterAppListViewState extends State<FlutterAppListView> {
  late Future<List<FlutterApp>> _appsFuture;

  @override
  void initState() {
    super.initState();
    _appsFuture = getApps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Apps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _appsFuture = getApps();
          });
        },
        child: FlutterAppListContent(_appsFuture)
      ),
    );
  }

  Future<List<FlutterApp>> getApps() async {
    // Get the token from the root isolate
    final rootIsolateToken = RootIsolateToken.instance!;

    return Isolate.run<List<FlutterApp>>(() async {
      // Initialize the binary messenger for the background isolate
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
      final detectorHostApi = DetectorHostApi();
      return await detectorHostApi.getApps();
    });
  }
}
