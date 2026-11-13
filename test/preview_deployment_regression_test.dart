import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import '../tool/write_preview_metadata.dart';

void main() {
  const commit = '0123456789abcdef0123456789abcdef01234567';
  test('merge builds use main when GitHub head-ref is empty', () {
    expect(
      environmentValue(
        {'GITHUB_HEAD_REF': '', 'GITHUB_REF_NAME': 'main'},
        ['VERCEL_GIT_COMMIT_REF', 'GITHUB_HEAD_REF', 'GITHUB_REF_NAME'],
      ),
      'main',
    );
    expect(
      environmentValue(
        {'VERCEL_GIT_COMMIT_REF': 'feature', 'GITHUB_REF_NAME': 'main'},
        ['VERCEL_GIT_COMMIT_REF', 'GITHUB_REF_NAME'],
      ),
      'feature',
    );
  });
  test('preview metadata records the exact deployed revision and UTC time', () {
    final metadata = previewMetadata(
      commit: commit,
      branch: 'main',
      version: '0.1.0',
      builtAt: DateTime.utc(2026, 11, 13, 10, 30),
    );
    final decoded = jsonDecode(jsonEncode(metadata)) as Map;
    expect(decoded['commit'], commit);
    expect(decoded['branch'], 'main');
    expect(decoded['builtAt'], '2026-11-13T10:30:00.000Z');
    expect(decoded['demo'], true);
    expect(
      decoded.keys,
      unorderedEquals([
        'schemaVersion',
        'commit',
        'branch',
        'appVersion',
        'builtAt',
        'demo',
      ]),
    );
  });
  test(
    'unknown or truncated revisions cannot be published as verified previews',
    () {
      for (final invalid in ['', 'HEAD', '0123456', 'x' * 40]) {
        expect(
          () => previewMetadata(
            commit: invalid,
            branch: 'main',
            version: '0.1.0',
            builtAt: DateTime.utc(2026),
          ),
          throwsArgumentError,
        );
      }
    },
  );
  test(
    'Vercel serves only compiled Flutter Web and revalidates update metadata',
    () {
      final config = jsonDecode(File('vercel.json').readAsStringSync()) as Map;
      expect(config['outputDirectory'], 'build/web');
      expect((config['git'] as Map)['deploymentEnabled'], {'main': false});
      final headers = config['headers'] as List;
      expect(
        headers.any(
          (entry) =>
              (entry['source'] as String).contains('preview-version.json') &&
              (entry['headers'] as List).any(
                (header) =>
                    header['key'] == 'Cache-Control' &&
                    (header['value'] as String).contains('no-cache'),
              ),
        ),
        true,
      );
      final build = File('tool/build_vercel.sh').readAsStringSync();
      expect(build, contains('--pwa-strategy=none'));
      expect(build, contains('flutter test --coverage --concurrency=1'));
    },
  );
}
