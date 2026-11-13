import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/data/sample_data.dart';
import 'package:tax_inspector_mobile/presentation/inspection/checklist_screen.dart';
import 'support/fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  testWidgets('seven-screen workflow submits and home progress updates', (
    tester,
  ) async {
    setPhone(tester);
    final controller = makeController();
    await tester.pumpWidget(InspectorApp(controller: controller));
    await tester.pumpAndSettle();
    expect(find.text('25%'), findsOneWidget);
    await tapKey(tester, 'next-visit');
    expect(find.text('تفاصيل الزيارة'), findsOneWidget);
    await tapKey(tester, 'start-visit');
    expect(find.text('قائمة التحقق'), findsOneWidget);
    for (final item in SampleData.checklist) {
      await tapKey(tester, 'check-${item.id}');
    }
    await tapKey(tester, 'result-false');
    await tapKey(tester, 'next-attachments');
    expect(find.text('صور الزيارة'), findsOneWidget);
    await tapKey(tester, 'next-report');
    expect(find.text('معاينة المحضر'), findsOneWidget);
    await tapKey(tester, 'submit-report');
    expect(find.text('تفاصيل المحضر'), findsOneWidget);
    expect(find.text('DEMO-V-0241'), findsOneWidget);
    expect(controller.inspectionFor('v2')!.submitted, true);
    await tapKey(tester, 'screen-back');
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 1200));
    await tester.pumpAndSettle();
    expect(find.text('50%'), findsOneWidget);
    await tester.tap(find.text('محاضري'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(SampleData.visits[1].name));
    await tester.pumpAndSettle();
    await tapKey(tester, 'return-reports');
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      2,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('language toggle and visits search expose empty state', (
    tester,
  ) async {
    setPhone(tester);
    await tester.pumpWidget(InspectorApp(controller: makeController()));
    await tester.pumpAndSettle();
    await tapKey(tester, 'language');
    expect(find.text('Good morning, Ahmed'), findsOneWidget);
    await tester.tap(find.text('My visits'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('visit-search')),
      'nothing matches',
    );
    await tester.pumpAndSettle();
    expect(find.text('No matching visits'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('checklist blocks advancing without required answers', (
    tester,
  ) async {
    setPhone(tester);
    final controller = makeController();
    await controller.initialize();
    final inspection = controller.start(SampleData.visits[1]);
    await pumpScreen(
      tester,
      controller,
      ChecklistScreen(inspection: inspection),
    );
    await tapKey(tester, 'next-attachments');
    expect(find.text('أكمل بنود المعاينة وحدد النتيجة أولًا'), findsOneWidget);
    expect(find.text('قائمة التحقق'), findsOneWidget);
  });
  testWidgets(
    'back saves draft before leaving and save failure keeps it open',
    (tester) async {
      setPhone(tester);
      final store = MemoryStore();
      final controller = makeController(store: store);
      await tester.pumpWidget(InspectorApp(controller: controller));
      await tester.pumpAndSettle();
      await tapKey(tester, 'next-visit');
      await tapKey(tester, 'start-visit');
      await tapKey(tester, 'check-business');
      store.failSave = true;
      await tapKey(tester, 'screen-back');
      await tester.pumpAndSettle();
      expect(find.text('قائمة التحقق'), findsOneWidget);
      expect(controller.inspectionFor('v2')!.checkedIds, contains('business'));
      store.failSave = false;
      await tapKey(tester, 'screen-back');
      await tester.pumpAndSettle();
      expect(find.text('تفاصيل الزيارة'), findsOneWidget);
      expect(store.writes, 1);
      final restarted = makeController(store: store);
      await restarted.initialize();
      expect(restarted.inspectionFor('v2')!.checkedIds, contains('business'));
      expect(tester.takeException(), isNull);
    },
  );
}
