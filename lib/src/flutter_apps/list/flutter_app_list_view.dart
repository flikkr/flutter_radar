import 'package:flutter/material.dart';
import 'package:flutter_radar/src/flutter_apps/flutter_app_controller.dart';
import 'package:flutter_radar/src/flutter_apps/list/flutter_app_list_content.dart';
import 'package:flutter_radar/src/settings/settings_controller.dart';

class FlutterAppListView extends StatelessWidget {
  static const routeName = '/';

  final FlutterAppController appController;
  final SettingsController settingsController;

  const FlutterAppListView({super.key, required this.appController, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Apps'),
        actions: [
          IconButton(
            icon: Icon(settingsController.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              final themeMode = settingsController.themeMode;
              settingsController.updateThemeMode(themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: FlutterAppListContent(appController),
    );
  }
}
