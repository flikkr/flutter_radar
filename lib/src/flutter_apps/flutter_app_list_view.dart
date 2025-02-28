import 'package:flutter/material.dart';
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
  final detectorHostApi = DetectorHostApi();
  late Future<List<FlutterApp>> apps;

  @override
  void initState() {
    super.initState();
    apps = detectorHostApi.getApps();
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
            apps = detectorHostApi.getApps();
          });
        },
        child: FutureBuilder<List<FlutterApp>>(
          future: apps,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
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
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
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
}
