import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/application/access_controller.dart';
import 'package:tax_inspector_mobile/application/report_browser_controller.dart';
import 'package:tax_inspector_mobile/data/sample_data.dart';
import 'package:tax_inspector_mobile/domain/access.dart';
import 'package:tax_inspector_mobile/domain/browse_choice.dart';
import 'package:tax_inspector_mobile/domain/business.dart';
import 'support/access_fakes.dart';
import 'support/fakes.dart';

void main() {
  test('visit tabs retain their date and completion rules', () async {
    final inspections = makeController();
    addTearDown(inspections.dispose);
    await inspections.initialize();
    final tomorrow = SampleData.date.add(const Duration(days: 1));
    expect(inspections.filtered(date: tomorrow).map((visit) => visit.id), [
      'v5',
    ]);
    expect(
      inspections.filtered(tab: 1, date: tomorrow).map((visit) => visit.id),
      ['v2', 'v3', 'v4', 'v5'],
    );
    expect(
      inspections.filtered(tab: 2, date: tomorrow).map((visit) => visit.id),
      ['v1'],
    );
    expect(
      inspections.filtered(tab: 99, date: tomorrow).map((visit) => visit.id),
      ['v5'],
    );
    final report = inspections.start(SampleData.visits[1]);
    completeChecklist(report);
    expect(await inspections.save(report, submit: true), isTrue);
    expect(inspections.filtered(tab: 2).map((visit) => visit.id), ['v1', 'v2']);
    expect(inspections.filtered(tab: 1).map((visit) => visit.id), [
      'v3',
      'v4',
      'v5',
    ]);
  });

  test('combined search preserves whitespace, case and priority fallback', () {
    final inspections = makeController();
    addTearDown(inspections.dispose);
    expect(
      inspections
          .filtered(
            query: ' SERVICES 10024587 ',
            area: 'سوق الجمعة',
            priority: 'high',
          )
          .map((visit) => visit.id),
      ['v2'],
    );
    expect(
      inspections.filtered(query: 'services', priority: 'normal'),
      isEmpty,
    );
    expect(inspections.filtered(priority: 'unknown').map((visit) => visit.id), [
      'v1',
      'v3',
      'v4',
      'v5',
    ]);
  });

  test(
    'business search keeps whole groups in first-seen order without mutation',
    () {
      final input = [
        SampleData.visits[4],
        SampleData.visits[1],
        SampleData.visits[0],
      ];
      final businesses = Business.fromVisits(input);
      expect(businesses.map((business) => business.taxNumber), [
        '10024581',
        '10024587',
      ]);
      expect(businesses.first.visits.map((visit) => visit.id), ['v1', 'v5']);
      expect(input.map((visit) => visit.id), ['v5', 'v2', 'v1']);
      expect(
        Business.fromVisits(input, query: 'TAJOURA 10024581').single.visits,
        businesses.first.visits,
      );
      expect(() => businesses.clear(), throwsUnsupportedError);
      expect(() => businesses.first.visits.clear(), throwsUnsupportedError);
    },
  );

  test(
    'report search keeps reverse insertion order and fixed-length results',
    () async {
      final inspections = makeController();
      addTearDown(inspections.dispose);
      await inspections.initialize();
      final first = inspections.start(SampleData.visits[2]);
      final second = inspections.start(SampleData.visits[1]);
      final browser = ReportBrowserController();
      addTearDown(browser.dispose);
      expect(browser.results(inspections), [second, first]);
      browser.setQuery('10024587 0241');
      expect(browser.results(inspections), [second]);
      completeChecklist(second);
      await inspections.save(second, submit: true);
      browser.setQuery('');
      browser.setFilter(ReportListFilter.drafts);
      expect(browser.results(inspections), [first]);
      browser.setFilter(ReportListFilter.review);
      final results = browser.results(inspections);
      expect(results, [second]);
      expect(() => results.add(first), throwsUnsupportedError);
    },
  );

  for (final intent in AccessIntent.values) {
    test('${intent.name} validates only its required form fields', () async {
      final service = FakeAccessService();
      final controller = AccessController(service: service);
      addTearDown(controller.dispose);
      final needsPassword = intent != AccessIntent.recovery;
      final needsName = intent == AccessIntent.signup;
      expect(
        await controller.submit(
          AccessRequest(
            intent: intent,
            email: 'inspector@example.test',
            password: needsPassword ? 'sample-only' : '',
            name: needsName ? 'أحمد الزروق' : '',
          ),
        ),
        isTrue,
      );
      expect(service.calls, 1);
      expect(controller.exploring, isFalse);
      expect(
        await controller.submit(
          AccessRequest(
            intent: intent,
            email: needsPassword ? 'inspector@example.test' : 'invalid',
            password: 'short',
            name: 'أ',
          ),
        ),
        isFalse,
      );
      expect(service.calls, 1);
    });
  }
}
