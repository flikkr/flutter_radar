import 'dart:convert';
import 'package:http/http.dart' as http;

/// A class representing the Flutter releases API.
class FlutterReleasesApi {
  /// The URL to fetch Flutter releases for macOS.
  static const String _releasesUrl =
      'https://storage.googleapis.com/flutter_infra_release/releases/releases_macos.json';

  /// The HTTP client used to make requests.
  final http.Client _client;

  /// Creates a new instance of [FlutterReleasesApi].
  ///
  /// If [client] is not provided, a new [http.Client] will be created.
  FlutterReleasesApi({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the Flutter releases data.
  ///
  /// Returns a [FlutterReleases] object containing the parsed releases data.
  /// Throws an exception if the request fails or the response cannot be parsed.
  Future<FlutterReleases> fetchReleases() async {
    try {
      final response = await _client.get(Uri.parse(_releasesUrl));

      if (response.statusCode == 200) {
        return FlutterReleases.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load Flutter releases: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load Flutter releases: $e');
    }
  }

  /// A static convenience method to fetch Flutter releases using a default client.
  static Future<FlutterReleases> fetchReleasesStatic() async {
    final api = FlutterReleasesApi();
    try {
      return await api.fetchReleases();
    } finally {
      api._client.close();
    }
  }
}

/// A class representing the Flutter releases data.
class FlutterReleases {
  final String baseUrl;
  final Map<String, String> currentRelease;
  final List<Release> releases;

  FlutterReleases({
    required this.baseUrl,
    required this.currentRelease,
    required this.releases,
  });

  factory FlutterReleases.fromJson(Map<String, dynamic> json) {
    return FlutterReleases(
      baseUrl: json['base_url'] as String,
      currentRelease: Map<String, String>.from(json['current_release'] as Map),
      releases: (json['releases'] as List).map((releaseJson) => Release.fromJson(releaseJson)).toList(),
    );
  }

  /// Gets the current stable release.
  Release? getCurrentStableRelease() {
    final stableHash = currentRelease['stable'];
    if (stableHash == null) return null;

    return releases.firstWhere(
      (release) => release.hash == stableHash && release.channel == 'stable',
      orElse: () => throw Exception('Current stable release not found'),
    );
  }

  /// Gets the current beta release.
  Release? getCurrentBetaRelease() {
    final betaHash = currentRelease['beta'];
    if (betaHash == null) return null;

    return releases.firstWhere(
      (release) => release.hash == betaHash && release.channel == 'beta',
      orElse: () => throw Exception('Current beta release not found'),
    );
  }

  /// Gets the current dev release.
  Release? getCurrentDevRelease() {
    final devHash = currentRelease['dev'];
    if (devHash == null) return null;

    return releases.firstWhere(
      (release) => release.hash == devHash && release.channel == 'dev',
      orElse: () => throw Exception('Current dev release not found'),
    );
  }

  /// Gets all stable channel releases.
  List<Release> getStableReleases() {
    return releases.where((release) => release.channel == 'stable').toList();
  }

  /// Gets all beta channel releases.
  List<Release> getBetaReleases() {
    return releases.where((release) => release.channel == 'beta').toList();
  }

  /// Gets all dev channel releases.
  List<Release> getDevReleases() {
    return releases.where((release) => release.channel == 'dev').toList();
  }
}

/// A class representing a single Flutter release.
class Release {
  final String hash;
  final String channel;
  final String version;
  final String releaseDate;
  final String archive;
  final String sha256;
  final String? dartSdkVersion;
  final String? dartSdkArch;

  Release({
    required this.hash,
    required this.channel,
    required this.version,
    required this.releaseDate,
    required this.archive,
    required this.sha256,
    this.dartSdkVersion,
    this.dartSdkArch,
  });

  factory Release.fromJson(Map<String, dynamic> json) {
    return Release(
      hash: json['hash'] as String,
      channel: json['channel'] as String,
      version: json['version'] as String,
      releaseDate: json['release_date'] as String,
      archive: json['archive'] as String,
      sha256: json['sha256'] as String,
      dartSdkVersion: json['dart_sdk_version'] as String?,
      dartSdkArch: json['dart_sdk_arch'] as String?,
    );
  }

  /// Gets the full download URL for this release.
  String getDownloadUrl(String baseUrl) {
    return '$baseUrl/$archive';
  }
}
