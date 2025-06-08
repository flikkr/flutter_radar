import 'package:flutter/material.dart';
import 'package:flutter_radar/src/detector.g.dart';
import 'package:flutter_radar/src/flutter_apps/details/flutter_app_details_view.dart';
import 'package:flutter_radar/src/flutter_apps/extension/flutter_app_ext.dart';
import 'package:flutter_radar/src/flutter_apps/list/ad_item.dart';

class FlutterAppListItem extends StatelessWidget {
  final FlutterApp app;
  final int index;

  const FlutterAppListItem({super.key, required this.app, required this.index});

  @override
  Widget build(BuildContext context) {
    final widget = ListTile(
      title: Text(app.label ?? '', style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(app.packageName),
      onTap: () {
        Navigator.pushNamed(context, FlutterAppDetailsView.routeName, arguments: app);
      },
      trailing: app.isDebug
          ? Chip(
              label: Text('Debug'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
              color: WidgetStateProperty.all(Theme.of(context).colorScheme.inversePrimary),
            )
          : null,
      leading: app.iconBytes != null
          ? Hero(tag: app.packageName, child: Image.memory(app.iconBytes!, width: 48, height: 48))
          : const Icon(Icons.app_registration),
    );

    // if (index % 3 == 0) {
    //   return Column(children: [widget, NativeAdItem()]);
    // }

    return widget;
  }
}
