import 'package:flutter/material.dart';
import 'package:flutter_radar/src/common/empty_view.dart';
import 'package:flutter_radar/src/detector.g.dart';
import 'package:flutter_radar/src/env.dart' as env;
import 'package:flutter_radar/src/flutter_apps/details/flutter_app_details_info.dart';
import 'package:flutter_radar/src/flutter_apps/details/package_item.dart';
import 'package:flutter_radar/src/flutter_apps/extension/flutter_app_ext.dart';
import 'package:flutter_radar/src/flutter_apps/list/ad_item.dart';

/// Displays detailed information about a FlutterApp.
class FlutterAppDetailsView extends StatefulWidget {
  final FlutterApp app;

  const FlutterAppDetailsView({super.key, required this.app});

  static const routeName = '/flutter_app';

  @override
  State<FlutterAppDetailsView> createState() => _FlutterAppDetailsViewState();
}

class _FlutterAppDetailsViewState extends State<FlutterAppDetailsView> {
  static const int _adFrequency = 20;

  final detectorHostApi = DetectorHostApi();
  late Future<List<String>> packages;

  @override
  void initState() {
    super.initState();
    packages = _fetchPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Details')),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            packages = _fetchPackages();
          });
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                height: 150,
                child: Hero(tag: widget.app.packageName, child: Image.memory(widget.app.iconBytes!)),
              ),
            ),
            SliverToBoxAdapter(child: FlutterAppDetailsInfo(app: widget.app)),
            FutureBuilder<List<String>>(
              future: packages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(child: const Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final items = snapshot.data!;
                  if (items.isEmpty) {
                    return SliverFillRemaining(
                      child: EmptyView.noApps(
                        title: widget.app.isDebug ? 'Cannot scan debug apps' : 'No packages found',
                      ),
                    );
                  } else {
                    return SliverList.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final widget = PackageItem(packageName: items[index]);
                        if (env.enableAds && index % _adFrequency == 0 && index != 0) {
                          return Column(children: [NativeAdItem(), widget]);
                        }
                        return widget;
                      },
                    );
                  }
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> _fetchPackages() async {
    if (widget.app.isDebug) {
      return [];
    }
    return await detectorHostApi.getPackages(appLibPath: widget.app.appLibPath!, zipEntryPath: widget.app.zipEntryPath);
  }
}
