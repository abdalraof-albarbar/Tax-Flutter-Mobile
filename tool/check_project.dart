import 'dart:io';
import 'package:tax_inspector_mobile/core/app_information.dart';

/// No external packages: this policy gate also runs before pub get.
void main() {
  final violations = <String>[];
  final result = Process.runSync('git', [
    'ls-files',
    '--cached',
    '--others',
    '--exclude-standard',
    '-z',
  ]);
  if (result.exitCode != 0) {
    stderr.writeln('Run this check from the Git repository root.');
    exit(1);
  }
  final paths = (result.stdout as String)
      .split('\u0000')
      .where((p) => p.isNotEmpty)
      .toSet();
  const generated = [
    'android/',
    'ios/',
    'web/icons/',
    'assets/',
    'output/',
    'build/',
  ];
  const extensions = [
    '.dart',
    '.md',
    '.yaml',
    '.yml',
    '.json',
    '.html',
    '.ps1',
    '.sh',
  ];
  for (final path in paths) {
    if (generated.any(path.startsWith) || !extensions.any(path.endsWith)) {
      continue;
    }
    final file = File(path);
    if (!file.existsSync()) continue;
    final count = file.readAsLinesSync().length;
    if (count > 300) violations.add('$path: $count lines (maximum 300)');
  }
  final pubspec = File('pubspec.yaml').readAsLinesSync();
  final version = pubspec
      .firstWhere((line) => line.startsWith('version:'))
      .split(':')
      .last
      .trim();
  if (version != AppInformation.version) {
    violations.add('pubspec version and AppInformation.version must match');
  }
  final release = File('docs/releases/$version.md');
  if (!release.existsSync() ||
      !release.readAsStringSync().contains('```mermaid')) {
    violations.add(
      'docs/releases/$version.md must exist with a Mermaid diagram',
    );
  }
  for (final path in paths.where(
    (path) => path.startsWith('docs/features/') && path.endsWith('.md'),
  )) {
    if (!File(path).readAsStringSync().contains('```mermaid')) {
      violations.add('$path must include a Mermaid diagram');
    }
  }
  final packageDoc = File('docs/PACKAGES.md').readAsStringSync();
  bool inDependencies = false;
  for (final line in pubspec) {
    if (line == 'dependencies:' || line == 'dev_dependencies:') {
      inDependencies = true;
    } else if (line.isNotEmpty &&
        !line.startsWith(' ') &&
        !line.startsWith('#')) {
      inDependencies = false;
    }
    if (!inDependencies) continue;
    final match = RegExp(r'^  ([a-z][a-z0-9_]*):').firstMatch(line);
    if (match != null && !packageDoc.contains('`${match[1]}`')) {
      violations.add('${match[1]} missing from docs/PACKAGES.md');
    }
  }
  if (violations.isNotEmpty) {
    stderr.writeln(violations.join('\n'));
    exit(1);
  }
  stdout.writeln(
    'PASS: files <=300 lines; packages, release and feature diagrams documented.',
  );
}
