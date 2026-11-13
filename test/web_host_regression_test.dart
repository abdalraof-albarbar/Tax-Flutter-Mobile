import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'web host leaves direction to Flutter to preserve semantic hit targets',
    () {
      // Reproduced in Chrome: a host dir=rtl shifted Flutter semantics targets,
      // causing Notifications to intercept EN and moving delete outside viewport.
      // Removing the host override restored normal clicks in both app locales.
      final host = File('web/index.html').readAsStringSync();
      final root = RegExp(
        r'<html\b[^>]*>',
        caseSensitive: false,
      ).firstMatch(host)!.group(0)!;
      expect(
        root,
        isNot(matches(RegExp(r'\bdir\s*=', caseSensitive: false))),
        reason:
            'MaterialApp supplies RTL; the HTML root must not apply it twice.',
      );
    },
  );
}
