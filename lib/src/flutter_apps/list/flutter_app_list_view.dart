import 'package:flutter/material.dart';
import 'package:flutter_detect/src/flutter_apps/flutter_app_controller.dart';
import 'package:flutter_detect/src/flutter_apps/list/flutter_app_list_content.dart';
import 'package:flutter_detect/src/settings/settings_view.dart';

class FlutterAppListView extends StatelessWidget {
  static const routeName = '/';

  final FlutterAppController controller;

  const FlutterAppListView({super.key, required this.controller});

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
      body: FlutterAppListContent(controller),
    );
  }
}
