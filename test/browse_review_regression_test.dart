import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/application/report_browser_controller.dart';
import 'package:tax_inspector_mobile/data/sample_data.dart';
import 'package:tax_inspector_mobile/domain/business.dart';
import 'package:tax_inspector_mobile/presentation/business/business_details_screen.dart';
import 'package:tax_inspector_mobile/presentation/visits/visit_filters.dart';
import 'support/fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  test(
    'reports can be found by every displayed code and the bare number',
    () async {
      final inspections = makeController();
      final browser = ReportBrowserController();
      addTearDown(inspections.dispose);
      addTearDown(browser.dispose);
      await inspections.initialize();
      final report = inspections.start(SampleData.visits[1]);
      for (final query in [
        '0241',
        '#0241',
        'DEMO-V-0241',
        ' demo-v-0241 ',
        '10024587 0241',
        'Al Nada',
      ]) {
        browser.setQuery(query);
        expect(browser.results(inspections), [report], reason: query);
      }
    },
  );

  testWidgets(
    'business reports distinguish unsaved drafts without hiding them',
    (tester) async {
      setPhone(tester);
      final inspections = makeController();
      await inspections.initialize();
      final report = inspections.start(SampleData.visits[1]);
      await pumpScreen(
        tester,
        inspections,
        BusinessDetailsScreen(
          business: Business.fromVisits(SampleData.visits)[1],
        ),
        language: 'en',
      );
      expect(find.text('Reports saved on this device'), findsNothing);
      expect(find.text('Unsaved draft'), findsOneWidget);
      expect(find.byKey(const ValueKey('report-v2')), findsOneWidget);
      expect(await inspections.save(report), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Unsaved draft'), findsNothing);
      expect(find.text('Draft'), findsOneWidget);
      expect(inspections.reports.single, same(report));
    },
  );

  for (final atEnd in [false, true]) {
    testWidgets(
      'week navigation includes the partial boundary week atEnd=$atEnd',
      (tester) async {
        setPhone(tester);
        var date = atEnd ? DateTime(2027, 12, 25) : DateTime(2026, 1, 4);
        final inspections = makeController();
        await inspections.initialize();
        await pumpScreen(
          tester,
          inspections,
          StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: DateStrip(
                date: date,
                onChanged: (value) => setState(() => date = value),
              ),
            ),
          ),
        );
        final direction = atEnd ? 'next-week' : 'previous-week';
        final button = find.byKey(ValueKey(direction));
        expect(tester.widget<TextButton>(button).onPressed, isNotNull);
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(date, atEnd ? DateTime(2027, 12, 31) : DateTime(2026, 1, 1));
        expect(tester.widget<TextButton>(button).onPressed, isNull);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final language in ['ar', 'en']) {
    for (final reducedMotion in [false, true]) {
      testWidgets(
        'week change reveals its date without moving the page: $language reduced=$reducedMotion',
        (tester) async {
          setPhone(tester, size: const Size(240, 800));
          final pageScroll = ScrollController(initialScrollOffset: 80);
          addTearDown(pageScroll.dispose);
          var date = SampleData.date;
          final inspections = makeController();
          await inspections.initialize();
          await pumpScreen(
            tester,
            inspections,
            StatefulBuilder(
              builder: (context, setState) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(disableAnimations: reducedMotion),
                child: Scaffold(
                  body: SingleChildScrollView(
                    controller: pageScroll,
                    child: Column(
                      children: [
                        const SizedBox(height: 150),
                        DateStrip(
                          date: date,
                          onChanged: (value) => setState(() => date = value),
                        ),
                        const SizedBox(height: 900),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            language: language,
            scale: 1.3,
          );
          final strip = find
              .descendant(
                of: find.byType(DateStrip),
                matching: find.byType(Scrollable),
              )
              .first;
          final position = tester.state<ScrollableState>(strip).position;
          position.jumpTo(position.maxScrollExtent);
          await tester.pumpAndSettle();
          final verticalOffset = pageScroll.offset;
          await tester.tap(find.byKey(const ValueKey('next-week')));
          await tester.pumpAndSettle();
          expect(date, SampleData.date.add(const Duration(days: 7)));
          final selected = find.descendant(
            of: find.byType(DateStrip),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics && widget.properties.selected == true,
            ),
          );
          final selectedRect = tester.getRect(selected);
          final viewportRect = tester.getRect(strip);
          expect(
            selectedRect.left,
            greaterThanOrEqualTo(viewportRect.left - .1),
          );
          expect(
            selectedRect.right,
            lessThanOrEqualTo(viewportRect.right + .1),
          );
          expect(pageScroll.offset, closeTo(verticalOffset, .1));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
