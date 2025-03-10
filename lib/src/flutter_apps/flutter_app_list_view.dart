import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show BackgroundIsolateBinaryMessenger, RootIsolateToken;
import 'package:flutter_detect/src/detector.g.dart';
import 'package:flutter_detect/src/settings/settings_view.dart';

import 'flutter_app_item.dart';

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
        child: FutureBuilder<List<FlutterApp>>(
          future: _appsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return SelectableText('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final items = snapshot.data!;
              if (items.isEmpty) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 32,
                        children: [
                          Text(
                            '🤖',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Text(
                            'No apps found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                itemCount: items.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Found ${items.length} apps',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    );
                  }
                  final item = items[index - 1];
                  return FlutterAppItem(app: item);
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
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
