import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/presentation/access/access_form_screen.dart';
import 'package:tax_inspector_mobile/presentation/access/access_result_screen.dart';
import 'package:tax_inspector_mobile/presentation/access/welcome_screen.dart';
import 'package:tax_inspector_mobile/presentation/essentials/privacy_screen.dart';
import 'support/access_widget_helpers.dart';
import 'support/access_fakes.dart';
import 'support/widget_helpers.dart';

Future<void> fillLogin(WidgetTester tester) async {
  await tapKey(tester, 'welcome-login');
  await enter(tester, 'access-email', 'inspector@example.test');
  await enter(tester, 'access-password', 'sample-only');
}

void main() {
  setUpAll(loadCairo);
  testWidgets(
    'a new invalid signup does not show the previous login service error',
    (tester) async {
      final service = FakeAccessService()..fail = true;
      await pumpAccess(tester, service: service);
      await fillLogin(tester);
      await tapKey(tester, 'access-submit');
      expect(find.textContaining('مدخلاتك باقية'), findsOneWidget);
      await tapKey(tester, 'access-switch-form');
      await tapKey(tester, 'access-submit');
      expect(find.text('اكتب بريدًا إلكترونيًا صالحًا'), findsOneWidget);
      expect(find.textContaining('مدخلاتك باقية'), findsNothing);
      expect(service.calls, 1);
    },
  );
  testWidgets('local validation clears an older error on the same form', (
    tester,
  ) async {
    final service = FakeAccessService()..fail = true;
    await pumpAccess(tester, service: service);
    await fillLogin(tester);
    await tapKey(tester, 'access-submit');
    expect(find.textContaining('مدخلاتك باقية'), findsOneWidget);
    await enter(tester, 'access-email', 'invalid');
    await tapKey(tester, 'access-submit');
    expect(find.textContaining('مدخلاتك باقية'), findsNothing);
    expect(service.calls, 1);
  });
  testWidgets(
    'privacy cannot cover a pending form and steal its result route',
    (tester) async {
      final pending = Completer<void>();
      final service = FakeAccessService()..completion = () => pending.future;
      await pumpAccess(tester, service: service);
      await fillLogin(tester);
      await tapKey(tester, 'access-submit');
      final privacy = find.widgetWithText(TextButton, 'الخصوصية وحدود التجربة');
      await tester.ensureVisible(privacy);
      await tester.pumpAndSettle();
      await tester.tap(privacy);
      await tester.pumpAndSettle();
      final openedPrivacy = find.byType(PrivacyScreen).evaluate().isNotEmpty;
      pending.complete();
      await tester.pumpAndSettle();
      expect(openedPrivacy, isFalse);
      expect(find.byType(AccessResultScreen), findsOneWidget);
      expect(find.byType(AccessFormScreen, skipOffstage: false), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('completion during back transition does not replace Welcome', (
    tester,
  ) async {
    final pending = Completer<void>();
    final service = FakeAccessService()..completion = () => pending.future;
    await pumpAccess(tester, service: service);
    await fillLogin(tester);
    await tapKey(tester, 'access-submit');
    final back = find.byKey(const ValueKey('access-back'));
    await tester.ensureVisible(back);
    await tester.pumpAndSettle();
    await tester.tap(back);
    await tester.pump();
    pending.complete();
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.byType(AccessResultScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
