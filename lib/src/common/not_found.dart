import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 32,
      children: [
        Text('🤖', style: textTheme.displayLarge),
        Text('No apps found', style: textTheme.titleLarge),
      ],
    );
  }
}
