import 'package:flutter/material.dart';
import 'package:flutter_detect/src/dialog/prominent_disclosure.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  static const routeName = '/settings';

  final SettingsController controller;

  const SettingsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: controller.themeMode,
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
          ),
          ListTile(
            title: Text('Consent to Data Collection'),
            onTap: () {
              if (controller.consentToDataCollection) {
                controller.updateConsentToDataCollection(false);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => ProminentDisclosureDialog(
                    onAccept: () {
                      controller.updateConsentToDataCollection(true);
                      Navigator.of(context).pop();
                    },
                    onNotNow: Navigator.of(context).pop,
                  ),
                );
              }
            },
            trailing: AbsorbPointer(
              absorbing: true,
              child: Switch(
                value: controller.consentToDataCollection,
                onChanged: (_) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
