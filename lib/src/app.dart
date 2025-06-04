import 'package:flutter/material.dart';
import 'package:flutter_detect/src/detector.g.dart';
import 'package:flutter_detect/src/flutter_apps/flutter_app_controller.dart';
import 'package:flutter_detect/src/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'flutter_apps/details/flutter_app_details_view.dart';
import 'flutter_apps/list/flutter_app_list_view.dart';
import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  final SettingsController settingsController;
  final FlutterAppController flutterAppController;

  const MyApp({
    super.key,
    required this.settingsController,
    required this.flutterAppController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case FlutterAppDetailsView.routeName:
                    final args = routeSettings.arguments as FlutterApp;
                    return FlutterAppDetailsView(app: args);
                  case FlutterAppListView.routeName:
                  default:
                    return FlutterAppListView(
                      appController: flutterAppController,
                      settingsController: settingsController,
                    );
                }
              },
            );
          },
        );
      },
    );
  }
}
