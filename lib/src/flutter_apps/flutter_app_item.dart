import 'package:flutter/material.dart';
import 'package:flutter_detect/src/detector.g.dart';
import 'package:flutter_detect/src/flutter_apps/flutter_app_details_view.dart';

class FlutterAppItem extends StatelessWidget {
  final FlutterApp app;
  final detectorHostApi = DetectorHostApi();

  FlutterAppItem({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(app.label ?? ''),
      subtitle: Text(app.packageName),
      onTap: () {
        Navigator.pushNamed(context, FlutterAppDetailsView.routeName, arguments: app);
      },
      trailing: SelectableText(app.version?.dartVersion ?? ''),
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
