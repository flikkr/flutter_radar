import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PackageItem extends StatelessWidget {
  static const String pubUrl = 'https://pub.dev/packages';
  static const String pubApiUrl = 'https://pub.dev/api/packages';
  final String packageName;

  const PackageItem({super.key, required this.packageName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(packageName),
      onTap: () => _handleTap(context),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    try {
      final exists = await _checkPackageExists();
      if (exists) {
        await _launchUrl();
      } else {
        // Show a snackbar or dialog indicating the package doesn't exist
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Package "$packageName" not found on pub.dev')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<bool> _checkPackageExists() async {
    try {
      final response = await http.get(Uri.parse('$pubApiUrl/$packageName'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _launchUrl() async {
    final url = Uri.parse('$pubUrl/$packageName');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
