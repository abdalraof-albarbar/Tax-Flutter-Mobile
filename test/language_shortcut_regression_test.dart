import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'support/fakes.dart';
import 'support/profile_fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  testWidgets('language shortcut waits for profile restoration', (
    tester,
  ) async {
    setPhone(tester);
    final gate = Completer<void>();
    addTearDown(() {
      if (!gate.isCompleted) gate.complete();
    });
    final store = DelayedProfileStore()..readGate = gate;
    final profile = makeProfile(store: store);
    await tester.pumpWidget(
      InspectorApp(controller: makeController(), profileController: profile),
    );
    await tester.pumpAndSettle();
    var button = tester.widget<TextButton>(
      find.byKey(const ValueKey('language')),
    );
    expect(button.onPressed, isNull);
    gate.complete();
    await tester.pumpAndSettle();
    button = tester.widget<TextButton>(find.byKey(const ValueKey('language')));
    expect(button.onPressed, isNotNull);
    await tapKey(tester, 'language');
    expect(profile.settings.language, 'en');
  });

  testWidgets('rapid language taps do not report a skipped save as a failure', (
    tester,
  ) async {
    setPhone(tester);
    final gate = Completer<void>();
    addTearDown(() {
      if (!gate.isCompleted) gate.complete();
    });
    final store = DelayedProfileStore()..writeGate = gate;
    final profile = makeProfile(store: store);
    await tester.pumpWidget(
      InspectorApp(controller: makeController(), profileController: profile),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('language')));
    await tester.tap(find.byKey(const ValueKey('language')));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
    final button = tester.widget<TextButton>(
      find.byKey(const ValueKey('language')),
    );
    expect(button.onPressed, isNull);
    gate.complete();
    await tester.pumpAndSettle();
    expect(profile.settings.language, 'en');
  });

  testWidgets('actual language storage failure still reports an error', (
    tester,
  ) async {
    setPhone(tester);
    final store = MemoryProfileStore()..failSave = true;
    final profile = makeProfile(store: store);
    await tester.pumpWidget(
      InspectorApp(controller: makeController(), profileController: profile),
    );
    await tester.pumpAndSettle();
    await tapKey(tester, 'language');
    expect(find.byType(SnackBar), findsOneWidget);
    expect(profile.settings.language, 'ar');
  });
}
