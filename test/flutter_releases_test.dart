import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_radar/src/network/flutter_releases.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('FlutterReleasesApi', () {
    late http.Client mockClient;
    late FlutterReleasesApi api;

    // Sample JSON response based on the actual API response structure
    final sampleResponse = {
      'base_url': 'https://storage.googleapis.com/flutter_infra_release/releases',
      'current_release': {
        'beta': '360a12c8481dccbfcab0a2a6704445e08454ef9e',
        'dev': '13a2fb10b838971ce211230f8ffdd094c14af02c',
        'stable': '35c388afb57ef061d06a39b537336c87e0e3d1b1',
      },
      'releases': [
        {
          'hash': '35c388afb57ef061d06a39b537336c87e0e3d1b1',
          'channel': 'stable',
          'version': '3.29.0',
          'dart_sdk_version': '3.7.0',
          'dart_sdk_arch': 'arm64',
          'release_date': '2025-02-12T18:10:55.366227Z',
          'archive': 'stable/macos/flutter_macos_arm64_3.29.0-stable.zip',
          'sha256': '8c3196363c7e79ead5bd2bd657cad6915afdf5b315ca51bfa7e569f490ec3de4',
        },
        {
          'hash': '360a12c8481dccbfcab0a2a6704445e08454ef9e',
          'channel': 'beta',
          'version': '3.30.0-0.1.pre',
          'dart_sdk_version': '3.8.0 (build 3.8.0-70.0.dev)',
          'dart_sdk_arch': 'arm64',
          'release_date': '2025-02-19T19:50:31.635799Z',
          'archive': 'beta/macos/flutter_macos_arm64_3.30.0-0.1.pre-beta.zip',
          'sha256': '0476925a316e5a4630b5d953b8fb14d233194cb6e0e5214eab7389e358d5d676',
        },
        {
          'hash': '13a2fb10b838971ce211230f8ffdd094c14af02c',
          'channel': 'dev',
          'version': 'v0.2.8',
          'release_date': '2018-04-03T01:45:21.158664Z',
          'archive': 'dev/macos/flutter_macos_v0.2.8-dev.zip',
          'sha256': 'ad3099a7fba340301d60f63d0f28b95885e58e4c3f86766c5b396980a94e7e86',
        },
      ],
    };

    setUp(() {
      // Create a mock HTTP client
      mockClient = MockClient((request) async {
        // Check if the request URL matches the expected URL
        if (request.url.toString() ==
            'https://storage.googleapis.com/flutter_infra_release/releases/releases_macos.json') {
          return http.Response(json.encode(sampleResponse), 200);
        }
        return http.Response('Not found', 404);
      });

      // Inject the mock client into the API
      api = FlutterReleasesApi(client: mockClient);
    });

    test('fetchReleases returns a FlutterReleases object on success', () async {
      final flutterReleases = await api.fetchReleases();

      expect(flutterReleases, isA<FlutterReleases>());
      expect(flutterReleases.baseUrl, 'https://storage.googleapis.com/flutter_infra_release/releases');
      expect(flutterReleases.currentRelease, isA<Map<String, String>>());
      expect(flutterReleases.releases.length, 3);
    });

    test('fetchReleases throws an exception on HTTP error', () async {
      // Create a mock client that returns an error
      final errorMockClient = MockClient((request) async {
        return http.Response('Server error', 500);
      });

      final errorApi = FlutterReleasesApi(client: errorMockClient);

      expect(() => errorApi.fetchReleases(), throwsA(isA<Exception>()));
    });

    test('getCurrentStableRelease returns the correct release', () async {
      final flutterReleases = await api.fetchReleases();

      final stableRelease = flutterReleases.getCurrentStableRelease();
      expect(stableRelease?.hash, '35c388afb57ef061d06a39b537336c87e0e3d1b1');
      expect(stableRelease?.version, '3.29.0');
      expect(stableRelease?.channel, 'stable');
    });

    test('getCurrentBetaRelease returns the correct release', () async {
      final flutterReleases = await api.fetchReleases();

      final betaRelease = flutterReleases.getCurrentBetaRelease();
      expect(betaRelease?.hash, '360a12c8481dccbfcab0a2a6704445e08454ef9e');
      expect(betaRelease?.version, '3.30.0-0.1.pre');
      expect(betaRelease?.channel, 'beta');
    });

    test('getCurrentDevRelease returns the correct release', () async {
      final flutterReleases = await api.fetchReleases();

      final devRelease = flutterReleases.getCurrentDevRelease();
      expect(devRelease?.hash, '13a2fb10b838971ce211230f8ffdd094c14af02c');
      expect(devRelease?.version, 'v0.2.8');
      expect(devRelease?.channel, 'dev');
    });

    test('getStableReleases returns only stable releases', () async {
      final flutterReleases = await api.fetchReleases();

      final stableReleases = flutterReleases.getStableReleases();
      expect(stableReleases.length, 1);
      expect(stableReleases[0].channel, 'stable');
      expect(stableReleases[0].version, '3.29.0');
    });

    test('getBetaReleases returns only beta releases', () async {
      final flutterReleases = await api.fetchReleases();

      final betaReleases = flutterReleases.getBetaReleases();
      expect(betaReleases.length, 1);
      expect(betaReleases[0].channel, 'beta');
      expect(betaReleases[0].version, '3.30.0-0.1.pre');
    });

    test('getDevReleases returns only dev releases', () async {
      final flutterReleases = await api.fetchReleases();

      final devReleases = flutterReleases.getDevReleases();
      expect(devReleases.length, 1);
      expect(devReleases[0].channel, 'dev');
      expect(devReleases[0].version, 'v0.2.8');
    });

    test('getDownloadUrl returns the correct URL', () async {
      final flutterReleases = await api.fetchReleases();
      final stableRelease = flutterReleases.getCurrentStableRelease();

      final downloadUrl = stableRelease!.getDownloadUrl(flutterReleases.baseUrl);

      expect(
        downloadUrl,
        'https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.29.0-stable.zip',
      );
    });

    test('Release.fromJson parses dart_sdk_version and dart_sdk_arch correctly', () async {
      final flutterReleases = await api.fetchReleases();
      final stableRelease = flutterReleases.getCurrentStableRelease();

      expect(stableRelease?.dartSdkVersion, '3.7.0');
      expect(stableRelease?.dartSdkArch, 'arm64');
    });
  });
}
