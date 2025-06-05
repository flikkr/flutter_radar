import 'package:flutter/material.dart';
import 'package:flutter_detect/src/common/empty_view.dart';
import 'package:flutter_detect/src/flutter_apps/flutter_app_controller.dart';
import 'package:flutter_detect/src/flutter_apps/flutter_app_service.dart';
import 'package:flutter_detect/src/flutter_apps/list/flutter_app_list_header.dart';
import 'package:flutter_detect/src/flutter_apps/list/flutter_app_list_item.dart';
import 'package:flutter_detect/src/flutter_apps/list/flutter_app_list_progress_indicator.dart';

class FlutterAppListContent extends StatefulWidget {
  final FlutterAppController controller;

  const FlutterAppListContent(this.controller, {super.key});

  @override
  State<FlutterAppListContent> createState() => _FlutterAppListContentState();
}

class _FlutterAppListContentState extends State<FlutterAppListContent> {
  late Stream<AppScanResult?> appsStream;

  @override
  void initState() {
    super.initState();
    appsStream = widget.controller.appScanStream();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          appsStream = widget.controller.appScanStream(forceRefresh: true);
        });
      },
      child: StreamBuilder(
        stream: appsStream,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _scrollView(SelectableText('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return _mainContent(snapshot.data!);
          }
          return const SizedBox.shrink();
        },
      ),
      // child: FutureBuilder<AppScanResult?>(
      //   future: appsFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return _showContent(
      //         SelectableText('Error: ${snapshot.error}'),
      //       );
      //     } else if (snapshot.hasData) {
      //       final result = snapshot.data!;
      //       if (result.apps.isEmpty) {
      //         return _showContent(
      //           Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             spacing: 32,
      //             children: [
      //               Text(
      //                 '🤖',
      //                 style: Theme.of(context).textTheme.displayLarge,
      //               ),
      //               Text(
      //                 'No apps found',
      //                 style: Theme.of(context).textTheme.titleLarge,
      //               ),
      //             ],
      //           ),
      //         );
      //       }
      //       return ListView.builder(
      //         itemCount: result.apps.length + 1,
      //         itemBuilder: (BuildContext context, int index) {
      //           if (index == 0) {
      //             return FlutterAppListHeader(result: result);
      //           }
      //           final item = result.apps[index - 1];
      //           return FlutterAppListItem(app: item);
      //         },
      //       );
      //     } else {
      //       return const SizedBox.shrink();
      //     }
      //   },
      // ),
    );
  }

  Widget _scrollView(Widget child) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [SliverFillRemaining(child: child)],
    );
  }

  Widget _mainContent(AppScanResult result) {
    final Widget widget;
    if (result.isScanComplete) {
      if (result.apps.isEmpty) {
        widget = _scrollView(EmptyView.noApps());
      } else {
        widget = ListView.builder(
          itemCount: result.apps.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return FlutterAppListHeader(result: result);
            }
            final item = result.apps[index - 1];
            return FlutterAppListItem(app: item);
          },
        );
      }
    } else {
      widget = Center(
        child: FlutterAppListProgressIndicator(value: result.progress, numFlutterApps: result.apps.length),
      );
    }
    return widget;
  }
}
