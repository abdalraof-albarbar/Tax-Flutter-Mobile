import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/application/access_controller.dart';
import 'package:tax_inspector_mobile/data/sample_data.dart';
import 'package:tax_inspector_mobile/presentation/access/access_result_screen.dart';
import 'package:tax_inspector_mobile/presentation/access/welcome_screen.dart';
import 'support/access_fakes.dart';
import 'support/fakes.dart';
import 'support/widget_helpers.dart';

Future<AccessController> pumpAccess(
  WidgetTester tester, {
  FakeAccessService? service,
  MemoryStore? store,
}) async {
  setPhone(tester);
  final access = AccessController(service: service ?? FakeAccessService());
  await tester.pumpWidget(
    InspectorApp(
      controller: makeController(store: store),
      accessController: access,
    ),
  );
  await tester.pumpAndSettle();
  return access;
}

Future<void> enter(WidgetTester tester, String key, String value) async {
  final field = find.byKey(ValueKey(key));
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.enterText(field, value);
  await tester.pump();
}

void main() {
  setUpAll(loadCairo);
  testWidgets(
    'welcome changes language and guides through all steps into demo',
    (tester) async {
      final access = await pumpAccess(tester);
      await tapKey(tester, 'access-language');
      expect(find.text('Every visit. A clearer next step.'), findsOneWidget);
      await tapKey(tester, 'welcome-guide');
      expect(find.text('Step 1 of 3'), findsOneWidget);
      await tapKey(tester, 'guide-next');
      expect(find.text('Step 2 of 3'), findsOneWidget);
      await tapKey(tester, 'guide-previous');
      expect(find.text('Step 1 of 3'), findsOneWidget);
      await tapKey(tester, 'guide-next');
      await tapKey(tester, 'guide-next');
      expect(find.text('Step 3 of 3'), findsOneWidget);
      await tapKey(tester, 'guide-next');
      expect(access.exploring, isTrue);
      expect(find.text('Good morning, Ahmed'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'login validates, toggles visibility and opens an explicitly demo result',
    (tester) async {
      final service = FakeAccessService();
      final access = await pumpAccess(tester, service: service);
      await tapKey(tester, 'welcome-login');
      await tapKey(tester, 'access-submit');
      expect(find.text('اكتب بريدًا إلكترونيًا صالحًا'), findsOneWidget);
      expect(service.calls, 0);
      await enter(tester, 'access-email', 'inspector@example.test');
      await enter(tester, 'access-password', 'sample-only');
      expect(
        tester
            .widget<TextField>(
              find.descendant(
                of: find.byKey(const ValueKey('access-password')),
                matching: find.byType(TextField),
              ),
            )
            .obscureText,
        isTrue,
      );
      await tapKey(tester, 'access-password-visibility');
      expect(
        tester
            .widget<TextField>(
              find.descendant(
                of: find.byKey(const ValueKey('access-password')),
                matching: find.byType(TextField),
              ),
            )
            .obscureText,
        isFalse,
      );
      await tapKey(tester, 'access-submit');
      expect(find.byType(AccessResultScreen), findsOneWidget);
      expect(access.exploring, isFalse);
      expect(service.calls, 1);
      expect(find.textContaining('هذا ليس دخولًا لحساب حقيقي'), findsOneWidget);
      await tapKey(tester, 'access-result-demo');
      expect(access.exploring, isTrue);
      expect(find.text('صباح الخير، أحمد'), findsOneWidget);
    },
  );
  testWidgets('signup blocks mismatch and missing demo acknowledgement', (
    tester,
  ) async {
    final service = FakeAccessService();
    await pumpAccess(tester, service: service);
    await tapKey(tester, 'welcome-signup');
    await enter(tester, 'access-name', 'أحمد الزروق');
    await enter(tester, 'access-email', 'inspector@example.test');
    await enter(tester, 'access-password', 'sample-only');
    await enter(tester, 'access-confirmation', 'different');
    await tapKey(tester, 'access-submit');
    expect(find.text('كلمتا المرور غير متطابقتين'), findsOneWidget);
    expect(service.calls, 0);
    await enter(tester, 'access-confirmation', 'sample-only');
    await tapKey(tester, 'access-submit');
    expect(service.calls, 0);
    await tapKey(tester, 'access-consent');
    await tapKey(tester, 'access-submit');
    expect(find.byType(AccessResultScreen), findsOneWidget);
    expect(find.textContaining('لم يُنشأ حساب حقيقي'), findsOneWidget);
    expect(service.calls, 1);
  });
  testWidgets('recovery makes no false email-sent claim', (tester) async {
    await pumpAccess(tester);
    await tapKey(tester, 'welcome-login');
    await tapKey(tester, 'access-forgot');
    expect(find.byKey(const ValueKey('access-password')), findsNothing);
    await enter(tester, 'access-email', 'inspector@example.test');
    await tapKey(tester, 'access-submit');
    expect(find.textContaining('لم يتم إرسال رابط استعادة'), findsOneWidget);
    expect(find.text('تم إرسال البريد'), findsNothing);
  });
  testWidgets('preview failure keeps form entries and retries successfully', (
    tester,
  ) async {
    final service = FakeAccessService()..fail = true;
    await pumpAccess(tester, service: service);
    await tapKey(tester, 'welcome-login');
    await enter(tester, 'access-email', 'inspector@example.test');
    await enter(tester, 'access-password', 'sample-only');
    await tapKey(tester, 'access-submit');
    expect(find.textContaining('مدخلاتك باقية'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('access-email')))
          .controller!
          .text,
      'inspector@example.test',
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('access-password')))
          .controller!
          .text,
      'sample-only',
    );
    service.fail = false;
    await tapKey(tester, 'access-submit');
    expect(find.byType(AccessResultScreen), findsOneWidget);
    expect(service.calls, 2);
  });
  testWidgets('ending demo confirms first and preserves inspection drafts', (
    tester,
  ) async {
    final store = MemoryStore();
    final access = await pumpAccess(tester, store: store);
    await tapKey(tester, 'welcome-demo');
    await tapKey(tester, 'next-visit');
    await tapKey(tester, 'start-visit');
    await tapKey(tester, 'check-business');
    await tapKey(tester, 'screen-back');
    await tapKey(tester, 'screen-back');
    final saved = store.source;
    await tapKey(tester, 'open-profile');
    await tapKey(tester, 'profile-end-demo');
    expect(find.text('إنهاء التجربة؟'), findsOneWidget);
    await tester.tap(find.text('البقاء'));
    await tester.pumpAndSettle();
    expect(access.exploring, isTrue);
    await tapKey(tester, 'profile-end-demo');
    await tapKey(tester, 'confirm-end-demo');
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(access.exploring, isFalse);
    expect(store.source, saved);
    final restored = makeController(store: store);
    await restored.initialize();
    expect(
      restored.inspectionFor(SampleData.visits[1].id)!.checkedIds,
      contains('business'),
    );
    await tapKey(tester, 'welcome-demo');
    expect(find.text('صباح الخير، أحمد'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
