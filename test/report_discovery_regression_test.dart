import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/data/sample_data.dart';
import 'support/fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  testWidgets(
    'reports filter, search, resume and preserve actual draft content',
    (tester) async {
      setPhone(tester);
      final controller = makeController();
      await controller.initialize();
      final draft = controller.start(SampleData.visits[1]);
      controller.toggleCheck(draft, 'business');
      draft.notes = 'ملاحظة تجريبية محفوظة';
      expect(await controller.save(draft), true);
      final submitted = controller.start(SampleData.visits[2]);
      completeChecklist(submitted);
      expect(await controller.save(submitted, submit: true), true);
      await tester.pumpWidget(InspectorApp(controller: controller));
      await tester.pumpAndSettle();
      await tester.tap(find.text('محاضري'));
      await tester.pumpAndSettle();
      await tapKey(tester, 'report-filter-ReportListFilter.drafts');
      expect(find.text('محضر واحد'), findsOneWidget);
      await tapKey(tester, 'report-v2');
      expect(find.text('قائمة التحقق'), findsOneWidget);
      expect(controller.inspectionFor('v2')!.notes, 'ملاحظة تجريبية محفوظة');
      expect(controller.inspectionFor('v2')!.checkedIds, contains('business'));
      await tapKey(tester, 'screen-back');
      await tester.enterText(
        find.byKey(const ValueKey('report-search')),
        'no match',
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'reset-browse');
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('report-search')))
            .controller!
            .text,
        isEmpty,
      );
      await tapKey(tester, 'report-filter-ReportListFilter.review');
      await tester.enterText(
        find.byKey(const ValueKey('report-search')),
        '0242',
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'report-v3');
      expect(find.text('DEMO-V-0242'), findsOneWidget);
      expect(controller.reports.length, 2);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('new browse controls expose names and minimum touch targets', (
    tester,
  ) async {
    setPhone(tester);
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(InspectorApp(controller: makeController()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('محاضري'));
      await tester.pumpAndSettle();
      expect(tester, meetsGuideline(labeledTapTargetGuideline));
      expect(tester, meetsGuideline(androidTapTargetGuideline));
      await tester.enterText(
        find.byKey(const ValueKey('report-search')),
        '0241',
      );
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tapKey(tester, 'report-search-clear');
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });
}
