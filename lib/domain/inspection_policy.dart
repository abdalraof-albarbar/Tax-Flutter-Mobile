import 'inspection.dart';
import 'visit.dart';

class InspectionPolicy {
  const InspectionPolicy({required this.checklist, required this.violations});
  final List<ChecklistItem> checklist;
  final List<NamedOption> violations;
  String? validate(Inspection inspection) {
    if (inspection.startedAt == null) return 'not_started';
    if (!checklist.every((item) => inspection.checkedIds.contains(item.id))) {
      return 'checklist';
    }
    if (inspection.hasFindings == null) return 'result';
    if (inspection.hasFindings == true &&
        (!violations.any((v) => v.id == inspection.violationId) ||
            inspection.notes.trim().isEmpty)) {
      return 'findings';
    }
    return null;
  }
}
