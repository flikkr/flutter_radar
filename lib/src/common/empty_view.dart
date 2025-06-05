import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String emoji;
  final String title;

  const EmptyView.noApps({super.key, String? emoji, String? title})
    : emoji = emoji ?? '🤖',
      title = title ?? 'No apps found';

  const EmptyView({super.key, required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 32,
      children: [
        Text(emoji, style: textTheme.displayLarge),
        Text(title, style: textTheme.titleLarge),
      ],
    );
  }
}
