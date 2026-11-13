import 'dart:convert';
import 'dart:typed_data';
import 'package:tax_inspector_mobile/application/inspection_controller.dart';
import 'package:tax_inspector_mobile/data/sample_data.dart';
import 'package:tax_inspector_mobile/domain/contracts.dart';
import 'package:tax_inspector_mobile/domain/inspection.dart';
import 'package:tax_inspector_mobile/domain/inspection_policy.dart';
import 'package:tax_inspector_mobile/domain/visit.dart';

class MemoryStore implements DraftStore {
  String source = '[]';
  bool failSave = false, failLoad = false;
  int writes = 0;
  @override
  Future<List<Inspection>> load() async {
    if (failLoad) throw StateError('simulated read failure');
    return (jsonDecode(source) as List)
        .map(
          (row) => Inspection.fromJson(Map<String, dynamic>.from(row as Map)),
        )
        .toList();
  }

  @override
  Future<void> save(List<Inspection> inspections) async {
    if (failSave) throw StateError('simulated disk full');
    source = jsonEncode(inspections.map((i) => i.toJson()).toList());
    writes++;
  }
}

class FakeAttachments implements AttachmentService {
  InspectionAttachment? result;
  bool fail = false;
  Future<InspectionAttachment?> _pick() async {
    if (fail) throw StateError('attachment_too_large');
    return result;
  }

  @override
  Future<InspectionAttachment?> pickDocument() => _pick();
  @override
  Future<InspectionAttachment?> pickPhoto({required bool camera}) => _pick();
}

class FakeDirections implements DirectionsService {
  @override
  Future<bool> open(Visit visit) async => true;
}

InspectionController makeController({
  MemoryStore? store,
  FakeAttachments? attachments,
}) => InspectionController(
  repository: DemoVisitRepository(),
  store: store ?? MemoryStore(),
  attachments: attachments ?? FakeAttachments(),
  directions: FakeDirections(),
  scheduleDate: SampleData.date,
  policy: const InspectionPolicy(
    checklist: SampleData.checklist,
    violations: SampleData.violations,
  ),
  clock: () => DateTime(2026, 11, 11, 10, 35),
);

void completeChecklist(Inspection inspection) {
  inspection.checkedIds.addAll(SampleData.checklist.map((item) => item.id));
  inspection.hasFindings = false;
}

InspectionAttachment fakePhoto() => InspectionAttachment(
  id: 'photo',
  name: 'photo.png',
  bytes: base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScLbtAAAAABJRU5ErkJggg==',
  ),
  isImage: true,
);
InspectionAttachment fakeDocument() => InspectionAttachment(
  id: 'pdf',
  name: 'visit.pdf',
  bytes: Uint8List.fromList(utf8.encode('%PDF-1.4 demo')),
  isImage: false,
);
