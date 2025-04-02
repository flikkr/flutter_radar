import 'package:flutter/material.dart';
import 'package:flutter_detect/src/flutter_apps/flutter_app_service.dart';
import 'package:intl/intl.dart';

class FlutterAppListHeader extends StatelessWidget {
  final AppScanResult result;

  const FlutterAppListHeader({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 0,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Found ${result.apps.length} apps',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Last scan: ${DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(result.lastScanTime))}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
