import 'dart:convert';
import 'dart:io';

Map<String, Object> previewMetadata({
  required String commit,
  required String branch,
  required String version,
  required DateTime builtAt,
}) {
  if (!RegExp(r'^[0-9a-f]{40}$').hasMatch(commit)) {
    throw ArgumentError(
      'A full Git commit SHA is required for preview evidence',
    );
  }
  if (branch.trim().isEmpty || version.trim().isEmpty) {
    throw ArgumentError('Branch and application version are required');
  }
  return {
    'schemaVersion': 1,
    'commit': commit,
    'branch': branch,
    'appVersion': version,
    'builtAt': builtAt.toUtc().toIso8601String(),
    'demo': true,
  };
}

String gitValue(List<String> arguments) {
  final result = Process.runSync('git', arguments);
  if (result.exitCode != 0) throw StateError('Git metadata is unavailable');
  return (result.stdout as String).trim();
}

String? environmentValue(Map<String, String> environment, List<String> keys) {
  for (final key in keys) {
    final value = environment[key]?.trim();
    if (value != null && value.isNotEmpty) return value;
  }
  return null;
}

void main() {
  final environment = Platform.environment;
  final commit =
      environmentValue(environment, ['VERCEL_GIT_COMMIT_SHA', 'GITHUB_SHA']) ??
      gitValue(['rev-parse', 'HEAD']);
  final branch =
      environmentValue(environment, [
        'VERCEL_GIT_COMMIT_REF',
        'GITHUB_HEAD_REF',
        'GITHUB_REF_NAME',
      ]) ??
      gitValue(['branch', '--show-current']);
  final pubspec = File('pubspec.yaml').readAsStringSync();
  final version = RegExp(
    r'^version:\s*(\S+)',
    multiLine: true,
  ).firstMatch(pubspec)!.group(1)!;
  final metadata = previewMetadata(
    commit: commit,
    branch: branch,
    version: version,
    builtAt: DateTime.now(),
  );
  final output = Directory('build/web');
  if (!File('${output.path}/index.html').existsSync()) {
    throw StateError('Build Flutter Web before writing preview metadata');
  }
  File('${output.path}/preview-version.json').writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(metadata)}\n',
  );
  stdout.writeln('Preview metadata written for $commit ($branch)');
}
