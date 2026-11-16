import 'dart:convert';
import 'dart:io';

/// SDK-only integration tests: the policy must not resolve app dependencies.
void main() {
  final fixture = Directory.systemTemp.createTempSync('tax-policy-');
  final fixtureRoot = fixture.absolute.path;
  final temporaryRoot =
      '${Directory.systemTemp.absolute.path}${Platform.pathSeparator}';
  if (!fixtureRoot.startsWith(temporaryRoot)) {
    throw StateError('Policy fixture escaped its temporary root');
  }
  void write(String path, String source) {
    final file = File('$fixtureRoot/$path');
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(source);
  }

  try {
    Process.runSync('git', ['init', '--quiet'], workingDirectory: fixtureRoot);
    write(
      'tool/check_project.dart',
      File('tool/check_project.dart').readAsStringSync(),
    );
    // An empty package map also prevents inheriting the parent app's config.
    write(
      'empty-packages.json',
      jsonEncode({'configVersion': 2, 'packages': []}),
    );
    write('pubspec.yaml', 'name: fixture\nversion: 0.2.0\n');
    write(
      'lib/core/app_information.dart',
      "class AppInformation { static const version = '0.2.0'; }\n",
    );
    write('docs/releases/0.2.0.md', '```mermaid\ngraph LR\n A --> B\n```\n');
    write('docs/PACKAGES.md', '# No dependencies\n');
    ProcessResult run() => Process.runSync(Platform.resolvedExecutable, [
      '--packages=$fixtureRoot/empty-packages.json',
      '$fixtureRoot/tool/check_project.dart',
    ], workingDirectory: fixtureRoot);
    void check(bool passed, String description, ProcessResult result) {
      if (!passed) {
        throw StateError('$description\n${result.stdout}\n${result.stderr}');
      }
      stdout.writeln('PASS: $description');
    }

    var result = run();
    check(
      result.exitCode == 0 &&
          !Directory('$fixtureRoot/.dart_tool').existsSync(),
      'clean checkout runs without package resolution',
      result,
    );
    write('pubspec.yaml', 'name: fixture\n');
    result = run();
    check(
      result.exitCode == 1 &&
          result.stderr.toString().contains('Missing version:'),
      'missing pubspec version is a policy diagnostic',
      result,
    );
    write('pubspec.yaml', 'name: fixture\nversion: 0.2.0\n');
    write(
      'lib/core/app_information.dart',
      "class AppInformation { static const version = '9.9.9'; }\n",
    );
    result = run();
    check(
      result.exitCode == 1 && result.stderr.toString().contains('must match'),
      'mismatched displayed version is rejected',
      result,
    );
  } finally {
    // Only delete the exact freshly-created child validated above.
    fixture.deleteSync(recursive: true);
  }
}
