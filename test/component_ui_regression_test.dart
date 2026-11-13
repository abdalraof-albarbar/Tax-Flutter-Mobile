import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/presentation/home/day_overview.dart';
import 'package:tax_inspector_mobile/presentation/home/next_visit_card.dart';
import 'package:tax_inspector_mobile/presentation/widgets/feedback.dart';
import 'support/fakes.dart';
import 'support/profile_fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  testWidgets(
    'completing the open visit retires its source card before return',
    (tester) async {
      setPhone(tester);
      final controller = makeController();
      await tester.pumpWidget(InspectorApp(controller: controller));
      await tester.pumpAndSettle();
      final cards = find.byType(NextVisitCard, skipOffstage: false);
      final original = tester.element(cards);
      final visit = tester.widget<NextVisitCard>(cards).visit;
      await tapKey(tester, 'next-visit');
      final inspection = controller.start(visit);
      completeChecklist(inspection);
      expect(await controller.save(inspection, submit: true), isTrue);
      await tester.pumpAndSettle();
      expect(original.mounted, isFalse);
      final next = tester.widget<NextVisitCard>(cards).visit;
      expect(next.id, isNot(visit.id));
      await tapKey(tester, 'screen-back');
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 1200));
      await tester.pumpAndSettle();
      expect(find.text('50%'), findsOneWidget);
      await tapKey(tester, 'next-visit');
      expect(find.text(next.name), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'route shortcut opens a usable sheet immediately with reduced motion',
    (tester) async {
      setPhone(tester);
      final profile = makeProfile();
      await profile.initialize();
      await profile.update(profile.settings.copyWith(reduceMotion: true));
      await tester.pumpWidget(
        InspectorApp(controller: makeController(), profileController: profile),
      );
      await tester.pumpAndSettle();
      final shortcut = find.byKey(const ValueKey('shortcut-route'));
      await tester.scrollUntilVisible(
        shortcut,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(shortcut);
      await tester.pump();
      expect(find.text('مسار الزيارات').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'dashboard shortcuts open reports, visits, help and the illustrative route',
    (tester) async {
      setPhone(tester);
      await tester.pumpWidget(InspectorApp(controller: makeController()));
      await tester.pumpAndSettle();
      await tapKey(tester, 'shortcut-reports');
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        2,
      );
      await tester.tap(find.text('الرئيسية'));
      await tester.pumpAndSettle();
      await tapKey(tester, 'shortcut-visits');
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        1,
      );
      await tester.tap(find.text('الرئيسية'));
      await tester.pumpAndSettle();
      await tapKey(tester, 'shortcut-help');
      expect(find.text('شن تبي تعرف؟'), findsOneWidget);
      await tapKey(tester, 'essentials-back');
      await tapKey(tester, 'shortcut-route');
      expect(find.text('مسار الزيارات'), findsOneWidget);
      expect(find.textContaining('الرسم توضيحي'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'ready-made container motion opens immediately when reduced motion is selected',
    (tester) async {
      setPhone(tester);
      final profile = makeProfile();
      await profile.initialize();
      await profile.update(profile.settings.copyWith(reduceMotion: true));
      await tester.pumpWidget(
        InspectorApp(controller: makeController(), profileController: profile),
      );
      await tester.pumpAndSettle();
      final button = find.byKey(const ValueKey('next-visit'));
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pump();
      await tester.pump();
      expect(
        find.byKey(const ValueKey('start-visit')).hitTestable(),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('zero scheduled visits has a valid zero progress indicator', (
    tester,
  ) async {
    setPhone(tester);
    await pumpScreen(
      tester,
      makeController(),
      const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: DayOverview(completed: 0, total: 0),
        ),
      ),
    );
    expect(find.text('0%'), findsOneWidget);
    expect(
      tester
          .widget<CircularProgressIndicator>(
            find.byType(CircularProgressIndicator),
          )
          .value,
      0,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'floating feedback remains readable and dismissible with narrow enlarged text',
    (tester) async {
      setPhone(tester, size: const Size(240, 800));
      await pumpScreen(
        tester,
        makeController(),
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showMessage(
                context,
                'تعذر الحفظ. حاول مجددًا؛ المسودة ما زالت مفتوحة',
                'Save failed. Retry; your draft is still open',
              ),
              child: const Text('Show'),
            ),
          ),
        ),
        scale: 2.08,
      );
      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();
      expect(find.textContaining('المسودة ما زالت مفتوحة'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(SnackBar), const Offset(0, 250));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
    },
  );
  for (final language in ['ar', 'en']) {
    for (final size in [
      const Size(240, 800),
      const Size(360, 740),
      const Size(1100, 850),
    ]) {
      testWidgets(
        'dashboard components fit $size $language and enlarged text',
        (tester) async {
          setPhone(tester, size: size);
          tester.platformDispatcher.textScaleFactorTestValue = size.width == 360
              ? 1.6
              : 1;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          final profile = makeProfile();
          await profile.initialize();
          await profile.update(
            profile.settings.copyWith(language: language, textScale: 1.3),
          );
          await tester.pumpWidget(
            InspectorApp(
              controller: makeController(),
              profileController: profile,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          final shortcut = find.byKey(const ValueKey('shortcut-route'));
          await tester.scrollUntilVisible(
            shortcut,
            300,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.pumpAndSettle();
          expect(shortcut.hitTestable(), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
