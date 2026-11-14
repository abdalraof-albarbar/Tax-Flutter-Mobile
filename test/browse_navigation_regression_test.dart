import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/presentation/visits/visits_screen.dart';
import 'package:tax_inspector_mobile/presentation/visits/visit_schedule_card.dart';
import 'package:tax_inspector_mobile/presentation/visits/visit_filter_sheet.dart';
import 'support/fakes.dart';
import 'support/profile_fakes.dart';
import 'support/widget_helpers.dart';

Future<void> openVisits(WidgetTester tester) async {
  await tester.tap(find.text('زياراتي'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadCairo);
  testWidgets(
    'reduced motion opens and closes transactional filters immediately',
    (tester) async {
      setPhone(tester);
      final profile = makeProfile();
      await profile.initialize();
      await profile.update(profile.settings.copyWith(reduceMotion: true));
      await tester.pumpWidget(
        InspectorApp(controller: makeController(), profileController: profile),
      );
      await tester.pumpAndSettle();
      await openVisits(tester);
      final button = find.byKey(const ValueKey('open-visit-filters'));
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pump();
      expect(
        tester.getSize(find.byType(VisitFilterSheet)).height,
        lessThan(tester.view.physicalSize.height * .7),
      );
      expect(
        find.byKey(const ValueKey('apply-visit-filters')).hitTestable(),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('apply-visit-filters')));
      await tester.pump();
      await tester.pump();
      expect(find.byType(VisitFilterSheet), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'search survives tab changes and can be cleared without losing drafts',
    (tester) async {
      setPhone(tester);
      final controller = makeController();
      await tester.pumpWidget(InspectorApp(controller: controller));
      await tester.pumpAndSettle();
      await openVisits(tester);
      await tester.enterText(
        find.byKey(const ValueKey('visit-search')),
        '10024587',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('الرئيسية'));
      await tester.pumpAndSettle();
      await openVisits(tester);
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('visit-search')))
            .controller!
            .text,
        '10024587',
      );
      await tapKey(tester, 'visit-search-clear');
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('visit-search')))
            .controller!
            .text,
        isEmpty,
      );
      expect(controller.reports, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'visit scrolling resumes at the same position after switching tabs',
    (tester) async {
      setPhone(tester);
      await tester.pumpWidget(InspectorApp(controller: makeController()));
      await tester.pumpAndSettle();
      await openVisits(tester);
      final scroll = find
          .descendant(
            of: find.byType(VisitsScreen),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.drag(scroll, const Offset(0, -500));
      await tester.pumpAndSettle();
      final offset = tester.state<ScrollableState>(scroll).position.pixels;
      expect(offset, greaterThan(0));
      await tester.tap(find.text('الرئيسية'));
      await tester.pumpAndSettle();
      await openVisits(tester);
      expect(
        tester.state<ScrollableState>(scroll).position.pixels,
        closeTo(offset, 1),
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'filters are transactional: cancel preserves results and apply changes them',
    (tester) async {
      setPhone(tester);
      await tester.pumpWidget(InspectorApp(controller: makeController()));
      await tester.pumpAndSettle();
      await openVisits(tester);
      await tapKey(tester, 'open-visit-filters');
      await tapKey(tester, 'visit-area-all');
      await tester.tap(find.text('سوق الجمعة').last);
      await tester.pumpAndSettle();
      await tapKey(tester, 'cancel-visit-filters');
      expect(find.text('4 زيارات'), findsOneWidget);
      await tapKey(tester, 'open-visit-filters');
      expect(find.byKey(const ValueKey('visit-area-all')), findsOneWidget);
      await tapKey(tester, 'visit-area-all');
      await tester.tap(find.text('سوق الجمعة').last);
      await tester.pumpAndSettle();
      await tapKey(tester, 'apply-visit-filters');
      expect(find.text('زيارة واحدة'), findsOneWidget);
      await tapKey(tester, 'reset-browse');
      expect(find.text('4 زيارات'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'empty dates recover to the sample schedule and system back returns home',
    (tester) async {
      setPhone(tester);
      await tester.pumpWidget(InspectorApp(controller: makeController()));
      await tester.pumpAndSettle();
      await openVisits(tester);
      await tapKey(tester, 'next-week');
      final empty = find.text('لا توجد زيارات مطابقة');
      await tester.scrollUntilVisible(
        empty,
        180,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(empty, findsOneWidget);
      await tapKey(tester, 'reset-browse');
      expect(find.text('4 زيارات'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        0,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'business directory opens grouped visits and creates no fictional reports',
    (tester) async {
      setPhone(tester);
      final controller = makeController();
      await tester.pumpWidget(InspectorApp(controller: controller));
      await tester.pumpAndSettle();
      await openVisits(tester);
      await tapKey(tester, 'open-business-directory');
      await tester.enterText(
        find.byKey(const ValueKey('business-search')),
        '10024581',
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'business-10024581');
      expect(find.byType(VisitScheduleCard), findsNWidgets(2));
      expect(controller.reports, isEmpty);
      await tapKey(tester, 'scheduled-visit-v5');
      await tapKey(tester, 'start-visit');
      expect(controller.inspectionFor('v5')!.submitted, false);
      await tapKey(tester, 'screen-back');
      await tapKey(tester, 'screen-back');
      await tapKey(tester, 'report-v5');
      expect(find.text('قائمة التحقق'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('empty reports offer a real route into the visit schedule', (
    tester,
  ) async {
    setPhone(tester);
    await tester.pumpWidget(InspectorApp(controller: makeController()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('محاضري'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('استعرض الزيارات'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );
    expect(tester.takeException(), isNull);
  });
}
