import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/application/visit_browser_controller.dart';
import 'package:tax_inspector_mobile/application/report_browser_controller.dart';
import 'package:tax_inspector_mobile/data/sample_data.dart';
import 'package:tax_inspector_mobile/domain/browse_choice.dart';
import 'package:tax_inspector_mobile/domain/business.dart';
import 'support/fakes.dart';

void main() {
  test(
    'visit filters compose and reset query, date, tab, ordering and choices',
    () async {
      final inspections = makeController();
      await inspections.initialize();
      final browser = VisitBrowserController(scheduleDate: SampleData.date);
      addTearDown(browser.dispose);
      browser.setQuery(' AL NADA ');
      browser.applyFilters(
        area: 'سوق الجمعة',
        priority: 'high',
        order: VisitOrder.priority,
      );
      expect(browser.results(inspections).map((v) => v.id), ['v2']);
      expect(browser.activeFilterCount, 3);
      browser.setTab(VisitListTab.upcoming);
      browser.setDate(SampleData.date.add(const Duration(days: 7)));
      browser.reset();
      expect(browser.isFiltered, false);
      expect(browser.activeFilterCount, 0);
      expect(browser.results(inspections).map((v) => v.id), [
        'v1',
        'v2',
        'v3',
        'v4',
      ]);
    },
  );
  test(
    'priority sorting is deterministic and does not reorder sample records',
    () async {
      final inspections = makeController();
      await inspections.initialize();
      final browser = VisitBrowserController(scheduleDate: SampleData.date);
      addTearDown(browser.dispose);
      browser.setOrder(VisitOrder.priority);
      expect(browser.results(inspections).map((v) => v.id), [
        'v2',
        'v1',
        'v3',
        'v4',
      ]);
      expect(SampleData.visits.map((v) => v.id), [
        'v1',
        'v2',
        'v3',
        'v4',
        'v5',
      ]);
    },
  );
  test(
    'report discovery follows real local submission state and both identifiers',
    () async {
      final inspections = makeController();
      await inspections.initialize();
      final report = inspections.start(SampleData.visits[1]);
      final browser = ReportBrowserController();
      addTearDown(browser.dispose);
      browser.setQuery('0241');
      expect(browser.results(inspections), [report]);
      browser.setQuery('10024587');
      browser.setFilter(ReportListFilter.review);
      expect(browser.results(inspections), isEmpty);
      completeChecklist(report);
      expect(await inspections.save(report, submit: true), true);
      expect(browser.results(inspections), [report]);
      browser.setFilter(ReportListFilter.drafts);
      expect(browser.results(inspections), isEmpty);
      browser.reset();
      expect(browser.results(inspections), [report]);
      expect(browser.isFiltered, false);
    },
  );
  test('businesses group by tax number and search the existing visit list', () {
    final businesses = Business.fromVisits(SampleData.visits);
    expect(businesses.length, 4);
    final bakery = Business.fromVisits(
      SampleData.visits,
      query: '10024581',
    ).single;
    expect(bakery.visits.map((v) => v.id), ['v1', 'v5']);
    expect(
      Business.fromVisits(
        SampleData.visits,
        query: ' AIN ZARA ',
      ).single.primary.id,
      'v4',
    );
    expect(Business.fromVisits([], query: 'anything'), isEmpty);
    expect(() => bakery.visits.clear(), throwsUnsupportedError);
  });
}
