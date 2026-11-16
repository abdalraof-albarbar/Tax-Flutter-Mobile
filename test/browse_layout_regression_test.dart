import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/application/visit_browser_controller.dart';
import 'package:tax_inspector_mobile/data/sample_data.dart';
import 'package:tax_inspector_mobile/domain/business.dart';
import 'package:tax_inspector_mobile/presentation/business/business_details_screen.dart';
import 'package:tax_inspector_mobile/presentation/business/business_directory_screen.dart';
import 'package:tax_inspector_mobile/presentation/reports/reports_screen.dart';
import 'package:tax_inspector_mobile/presentation/visits/visit_filter_sheet.dart';
import 'package:tax_inspector_mobile/presentation/visits/visits_screen.dart';
import 'support/fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  for (final language in ['ar', 'en']) {
    for (final width in [240.0, 360.0, 1100.0]) {
      testWidgets(
        'browse pages fit $language at width $width with enlarged text',
        (tester) async {
          setPhone(tester, size: Size(width, 850));
          final controller = makeController();
          await controller.initialize();
          final draft = controller.start(SampleData.visits[1]);
          completeChecklist(draft);
          final browser = VisitBrowserController(scheduleDate: SampleData.date);
          addTearDown(browser.dispose);
          final screens = <Widget>[
            const Scaffold(body: VisitsScreen()),
            const Scaffold(body: ReportsScreen()),
            const BusinessDirectoryScreen(),
            BusinessDetailsScreen(
              business: Business.fromVisits(SampleData.visits).first,
            ),
            Scaffold(body: VisitFilterSheet(browser: browser)),
          ];
          for (final screen in screens) {
            await pumpScreen(
              tester,
              controller,
              screen,
              language: language,
              scale: width == 360 ? 2.08 : 1.3,
            );
            expect(
              tester.takeException(),
              isNull,
              reason: '${screen.runtimeType} initial',
            );
            await tester.drag(
              find.byType(Scrollable).first,
              const Offset(0, -1600),
            );
            await tester.pumpAndSettle();
            expect(
              tester.takeException(),
              isNull,
              reason: '${screen.runtimeType} scrolled',
            );
          }
        },
      );
    }
  }
}
