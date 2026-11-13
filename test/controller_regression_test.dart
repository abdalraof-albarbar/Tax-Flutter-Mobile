import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/data/sample_data.dart';
import 'package:tax_inspector_mobile/domain/inspection.dart';
import 'package:tax_inspector_mobile/domain/visit.dart';
import 'support/fakes.dart';

void main() {
  test('search supports Arabic, English, whitespace and tax number', () async {
    final controller = makeController();
    await controller.initialize();
    for (final query in ['الندى', ' AL NADA ', '10024587']) {
      expect(controller.filtered(query: query).single.id, 'v2');
    }
    expect(controller.filtered(query: 'not found'), isEmpty);
  });
  test('date, area, priority and status filters compose', () async {
    final controller = makeController();
    await controller.initialize();
    expect(controller.filtered(date: SampleData.date), hasLength(4));
    expect(
      controller.filtered(area: 'سوق الجمعة', priority: 'high').single.id,
      'v2',
    );
    expect(controller.filtered(area: 'تاجوراء', priority: 'high'), isEmpty);
    expect(controller.filtered(tab: 2).single.id, 'v1');
    expect(controller.filtered(tab: 1), hasLength(4));
    expect(controller.filtered(date: DateTime(2026, 11, 12)).single.id, 'v5');
  });
  test(
    'starting twice keeps report identity and original start time',
    () async {
      final controller = makeController();
      await controller.initialize();
      final visit = SampleData.visits[1];
      final first = controller.start(visit);
      expect(controller.start(visit), same(first));
      expect(first.reportNumber, '0241');
      expect(first.startedAt, DateTime(2026, 11, 11, 10, 35));
      expect(controller.statusOf(visit), VisitStatus.active);
    },
  );
  test('completed reference visit cannot be restarted', () async {
    final controller = makeController();
    await controller.initialize();
    expect(() => controller.start(SampleData.visits[0]), throwsStateError);
  });
  test('incomplete checklist and missing result block submission', () async {
    final store = MemoryStore();
    final controller = makeController(store: store);
    await controller.initialize();
    final draft = controller.start(SampleData.visits[1]);
    expect(controller.validationError(draft), 'checklist');
    expect(await controller.save(draft, submit: true), false);
    draft.checkedIds.addAll(SampleData.checklist.map((item) => item.id));
    expect(controller.validationError(draft), 'result');
    expect(store.writes, 0);
  });
  test('findings require a known type and nonblank notes', () async {
    final controller = makeController();
    await controller.initialize();
    final draft = controller.start(SampleData.visits[1]);
    completeChecklist(draft);
    draft.hasFindings = true;
    expect(controller.validationError(draft), 'findings');
    draft.violationId = 'unknown';
    draft.notes = 'note';
    expect(controller.validationError(draft), 'findings');
    draft.violationId = SampleData.violations.first.id;
    draft.notes = '  ';
    expect(controller.validationError(draft), 'findings');
    draft.notes = 'Document missing';
    expect(controller.validationError(draft), isNull);
  });
  test(
    'successful submission persists, completes visit and freezes checklist',
    () async {
      final store = MemoryStore();
      final controller = makeController(store: store);
      await controller.initialize();
      final visit = SampleData.visits[1];
      final draft = controller.start(visit);
      completeChecklist(draft);
      expect(await controller.save(draft, submit: true), true);
      expect(controller.statusOf(visit), VisitStatus.completed);
      controller.toggleCheck(draft, SampleData.checklist.first.id);
      expect(draft.checkedIds, hasLength(3));
      final restored = makeController(store: store);
      await restored.initialize();
      expect(restored.inspectionFor(visit.id)!.submitted, true);
      expect(restored.filtered(tab: 2), hasLength(2));
    },
  );
  test('failed submission rolls back status and permits retry', () async {
    final store = MemoryStore()..failSave = true;
    final controller = makeController(store: store);
    await controller.initialize();
    final visit = SampleData.visits[1];
    final draft = controller.start(visit);
    completeChecklist(draft);
    expect(await controller.save(draft, submit: true), false);
    expect(draft.submittedAt, isNull);
    expect(draft.savedAt, isNull);
    expect(controller.statusOf(visit), VisitStatus.active);
    expect(controller.busy, false);
    store.failSave = false;
    expect(await controller.save(draft, submit: true), true);
  });
  test(
    'unfinished draft roundtrip preserves notes, results and attachment bytes',
    () async {
      final store = MemoryStore();
      final controller = makeController(store: store);
      await controller.initialize();
      final draft = controller.start(SampleData.visits[1]);
      draft.notes = 'ملاحظة';
      draft.attachmentNotes = 'تفاصيل';
      draft.checkedIds.add('business');
      draft.hasFindings = true;
      draft.violationId = 'documents';
      draft.attachments.addAll([fakePhoto(), fakeDocument()]);
      expect(await controller.save(draft), true);
      final restored = makeController(store: store);
      await restored.initialize();
      final loaded = restored.inspectionFor(draft.visitId)!;
      expect(loaded.toJson(), draft.toJson());
      expect(loaded.photoCount, 1);
      expect(loaded.documentCount, 1);
      expect(loaded.submitted, false);
    },
  );
  test(
    'picker cancellation, size errors and limit preserve existing attachments',
    () async {
      final picker = FakeAttachments();
      final controller = makeController(attachments: picker);
      await controller.initialize();
      final draft = controller.start(SampleData.visits[1]);
      expect(await controller.addAttachment(draft, camera: false), false);
      expect(draft.attachments, isEmpty);
      picker.fail = true;
      expect(await controller.addAttachment(draft, camera: true), false);
      expect(controller.error, 'size');
      picker.fail = false;
      picker.result = fakePhoto();
      for (var i = 0; i < 6; i++) {
        expect(await controller.addAttachment(draft), true);
      }
      expect(await controller.addAttachment(draft), false);
      expect(controller.error, 'attachment_limit');
      expect(draft.attachments, hasLength(6));
    },
  );
  test('restoration failure blocks writes to protect persisted data', () async {
    final store = MemoryStore()..failLoad = true;
    final controller = makeController(store: store);
    await controller.initialize();
    expect(controller.error, 'load');
    expect(() => controller.start(SampleData.visits[1]), throwsStateError);
    expect(
      await controller.save(Inspection(visitId: 'v2', reportNumber: '0241')),
      false,
    );
    expect(store.writes, 0);
    store.failLoad = false;
    await controller.initialize();
    expect(controller.error, isNull);
    expect(controller.start(SampleData.visits[1]).visitId, 'v2');
  });
}
