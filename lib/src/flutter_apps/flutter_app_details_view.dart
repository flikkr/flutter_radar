import 'package:flutter/material.dart';
import 'package:flutter_detect/src/detector.g.dart';
import 'package:flutter_detect/src/flutter_apps/package_item.dart';

/// Displays detailed information about a FlutterApp.
class FlutterAppDetailsView extends StatefulWidget {
  final FlutterApp app;

  const FlutterAppDetailsView({
    super.key,
    required this.app,
  });

  static const routeName = '/flutter_app';

  @override
  State<FlutterAppDetailsView> createState() => _FlutterAppDetailsViewState();
}

class _FlutterAppDetailsViewState extends State<FlutterAppDetailsView> {
  final detectorHostApi = DetectorHostApi();
  late Future<List<String>> packages;

  @override
  void initState() {
    super.initState();
    packages = detectorHostApi.getPackages(widget.app.packageName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Details'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            packages = detectorHostApi.getPackages(widget.app.packageName);
          });
        },
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Hero(
                tag: widget.app.packageName,
                child: Image.memory(widget.app.iconBytes!),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: packages,
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
                                  'No packages found',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = items[index];
                        return PackageItem(packageName: item);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
