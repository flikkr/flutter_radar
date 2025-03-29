import 'package:flutter/material.dart';
import 'package:flutter_detect/src/detector.g.dart';
import 'package:flutter_detect/src/flutter_apps/flutter_app_item.dart';

class FlutterAppListContent extends StatelessWidget {
  final Future<List<FlutterApp>> appsFuture;

  const FlutterAppListContent(this.appsFuture, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlutterApp>>(
      future: appsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return _showContent(
            SelectableText('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final items = snapshot.data!;
          if (items.isEmpty) {
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
