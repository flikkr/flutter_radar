import 'package:flutter/material.dart';
import 'package:flutter_detect/src/detector.g.dart';
import 'package:flutter_detect/src/flutter_apps/flutter_app_controller.dart';
import 'package:flutter_detect/src/flutter_apps/flutter_app_service.dart';
import 'package:flutter_detect/src/flutter_apps/list/flutter_app_list_header.dart';
import 'package:flutter_detect/src/flutter_apps/list/flutter_app_list_item.dart';

class FlutterAppListContent extends StatefulWidget {
  final FlutterAppController controller;

  const FlutterAppListContent(this.controller, {super.key});

  @override
  State<FlutterAppListContent> createState() => _FlutterAppListContentState();
}

class _FlutterAppListContentState extends State<FlutterAppListContent> {
  late Future<AppScanResult?> appsFuture;

  @override
  void initState() {
    super.initState();
    appsFuture = widget.controller.getApps();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          appsFuture = widget.controller.getApps(forceRefresh: true);
        });
      },
      child: FutureBuilder<AppScanResult?>(
        future: appsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _showContent(
              SelectableText('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final result = snapshot.data!;
            if (result.apps.isEmpty) {
              return _showContent(
                Column(
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
              );
            }
            return ListView.builder(
              itemCount: result.apps.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return FlutterAppListHeader(result: result);
                }
                final item = result.apps[index - 1];
                return FlutterAppListItem(app: item);
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _showContent(Widget child) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(child: child),
      ],
    );
  }
}
