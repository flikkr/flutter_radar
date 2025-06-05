import 'package:flutter/material.dart';
import 'package:flutter_radar/src/detector.g.dart';
import 'package:flutter_radar/src/flutter_apps/extension/flutter_app_ext.dart';

class FlutterAppDetailsInfo extends StatefulWidget {
  final FlutterApp app;

  const FlutterAppDetailsInfo({super.key, required this.app});

  @override
  State<FlutterAppDetailsInfo> createState() => _FlutterAppDetailsInfoState();
}

class _FlutterAppDetailsInfoState extends State<FlutterAppDetailsInfo> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Text('App Details', style: Theme.of(context).textTheme.titleLarge),
            // const SizedBox(height: 8),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: _isExpanded ? null : 120,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildRow('App Name', widget.app.label ?? ''),
                      _buildRow('Package Name', widget.app.packageName),
                      _buildRow('App Version', widget.app.appVersion ?? 'N/A'),
                      _buildRow('Version', widget.app.version?.toString() ?? 'N/A'),
                      _buildRow('Debug App', widget.app.isDebug ? 'True' : 'False'),
                      _buildRow('Flutter Library Path', widget.app.flutterLibPath),
                      _buildRow('App Library Path', widget.app.appLibPath ?? 'N/A'),
                      _buildRow('Zip Entry Path', widget.app.zipEntryPath ?? 'N/A'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                icon: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: _isExpanded ? 0.5 : 0,
                  child: const Icon(Icons.expand_more),
                ),
                label: Text(_isExpanded ? 'Show Less' : 'Show More'),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(padding: const EdgeInsets.only(right: 16), child: Text(label)),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }
}
