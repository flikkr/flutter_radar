import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PackageItem extends StatelessWidget {
  static const String pubUrl = 'https://pub.dev';
  static const String pubPackages = '$pubUrl/packages';
  static const String pubPackagesApi = '$pubUrl/api/packages';
  final String packageName;

  const PackageItem({super.key, required this.packageName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(packageName),
      onTap: () => _handleTap(context),
      visualDensity: VisualDensity(vertical: -4),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    final scaffold = ScaffoldMessenger.of(context);
    try {
      final exists = await _checkPackageExists();
      if (exists) {
        await _launchUrl();
      } else {
        // Show a snackbar or dialog indicating the package doesn't exist
        if (context.mounted) {
          scaffold.showSnackBar(
            SnackBar(
              content: Text(
                'Package "$packageName" not found on pub.dev. Could be a private package.',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        scaffold.showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<bool> _checkPackageExists() async {
    try {
      final response = await http.get(
        Uri.parse('$pubPackagesApi/$packageName'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _launchUrl() async {
    final url = Uri.parse('$pubPackages/$packageName');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
