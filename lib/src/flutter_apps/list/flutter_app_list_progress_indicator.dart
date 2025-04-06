import 'package:flutter/material.dart';

class FlutterAppListProgressIndicator extends StatelessWidget {
  final double value;
  final int numFlutterApps;

  const FlutterAppListProgressIndicator({
    super.key,
    required this.value,
    required this.numFlutterApps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            value: value,
          ),
        ),
        Text(
          'Found $numFlutterApps Flutter apps',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
