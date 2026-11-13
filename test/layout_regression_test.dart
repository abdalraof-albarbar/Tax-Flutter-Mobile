import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/data/sample_data.dart';
import 'package:tax_inspector_mobile/presentation/home/home_screen.dart';
import 'package:tax_inspector_mobile/presentation/inspection/attachments_screen.dart';
import 'package:tax_inspector_mobile/presentation/inspection/checklist_screen.dart';
import 'package:tax_inspector_mobile/presentation/inspection/report_preview_screen.dart';
import 'package:tax_inspector_mobile/presentation/reports/report_details_screen.dart';
import 'package:tax_inspector_mobile/presentation/visits/visit_details_screen.dart';
import 'package:tax_inspector_mobile/presentation/visits/visits_screen.dart';
import 'support/fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  for (final size in [const Size(360, 800), const Size(900, 850)]) {
    for (final language in ['ar', 'en']) {
      testWidgets(
        'all reference screens fit $size $language at 1.3 text scale',
        (tester) async {
          setPhone(tester, size: size);
          final controller = makeController();
          await controller.initialize();
          final draft = controller.start(SampleData.visits[1]);
          completeChecklist(draft);
          final screens = <Widget>[
            Scaffold(body: HomeScreen(onShowVisits: () {})),
            const Scaffold(body: VisitsScreen()),
            VisitDetailsScreen(visit: SampleData.visits[1]),
            ChecklistScreen(inspection: draft),
            AttachmentsScreen(inspection: draft),
            ReportPreviewScreen(inspection: draft),
            ReportDetailsScreen(inspection: draft),
          ];
          for (final screen in screens) {
            await pumpScreen(
              tester,
              controller,
              screen,
              language: language,
              scale: 1.3,
            );
            expect(
              tester.takeException(),
              isNull,
              reason: '${screen.runtimeType} initial',
            );
            final scrollables = find.byType(Scrollable);
            if (scrollables.evaluate().isNotEmpty) {
              await tester.drag(scrollables.first, const Offset(0, -1500));
              await tester.pumpAndSettle();
              expect(
                tester.takeException(),
                isNull,
                reason: '${screen.runtimeType} scrolled',
              );
            }
          }
        },
      );
    }
  }
}
