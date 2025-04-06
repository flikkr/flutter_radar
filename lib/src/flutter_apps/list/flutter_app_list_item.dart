import 'package:flutter/material.dart';
import 'package:flutter_detect/src/detector.g.dart';
import 'package:flutter_detect/src/flutter_apps/details/flutter_app_details_view.dart';
import 'package:flutter_detect/src/flutter_apps/extension/flutter_app_ext.dart';

class FlutterAppListItem extends StatelessWidget {
  final FlutterApp app;

  const FlutterAppListItem({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        app.label ?? '',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(app.packageName),
      onTap: () {
        Navigator.pushNamed(context, FlutterAppDetailsView.routeName, arguments: app);
      },
      trailing: app.isDebug
          ? Chip(
              label: Text('Debug'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
              color: WidgetStateProperty.all(Theme.of(context).colorScheme.inversePrimary),
            )
          : null,
      leading: app.iconBytes != null
          ? Hero(
              tag: app.packageName,
              child: Image.memory(
                app.iconBytes!,
                width: 48,
                height: 48,
              ),
            )
          : const Icon(Icons.app_registration),
    );
  }
}
