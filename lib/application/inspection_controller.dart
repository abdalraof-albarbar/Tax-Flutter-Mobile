import 'package:flutter/foundation.dart';
import '../domain/inspection_policy.dart';
import '../domain/contracts.dart';
import '../domain/inspection.dart';
import '../domain/visit.dart';

class InspectionController extends ChangeNotifier {
  InspectionController({
    required this.repository,
    required this.store,
    required this.attachments,
    required this.directions,
    required this.policy,
    required this.scheduleDate,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;
  final VisitRepository repository;
  final DraftStore store;
  final AttachmentService attachments;
  final DirectionsService directions;
  final InspectionPolicy policy;
  final DateTime scheduleDate;
  bool _restored = false;
  final DateTime Function() clock;
  final Map<String, Inspection> _inspections = {};
  bool loading = true, busy = false;
  String? error;
  List<Visit> get visits => repository.visits;
  List<Inspection> get reports => List.unmodifiable(_inspections.values);
  Inspection? inspectionFor(String id) => _inspections[id];
  Visit visitFor(String id) => visits.firstWhere((v) => v.id == id);
  Future<void> initialize() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final saved = await store.load();
      _restored = true;
      _inspections.addEntries(
        saved
            .where((i) => visits.any((v) => v.id == i.visitId))
            .map((i) => MapEntry(i.visitId, i)),
      );
    } catch (_) {
      _restored = false;
      error = 'load';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  VisitStatus statusOf(Visit visit) {
    final inspection = inspectionFor(visit.id);
    if (inspection?.submitted ?? false) return VisitStatus.completed;
    if (inspection?.startedAt != null) return VisitStatus.active;
    return visit.status;
  }

  List<Visit> filtered({
    String query = '',
    String area = 'all',
    String priority = 'all',
    DateTime? date,
    int tab = 0,
  }) {
    final term = query.trim().toLowerCase();
    return visits.where((v) {
      final matches = '${v.name} ${v.englishName} ${v.taxNumber}'
          .toLowerCase()
          .contains(term);
      final sameDay = date == null || sameDate(v.date, date);
      final status = statusOf(v);
      final inTab = switch (tab) {
        1 => status != VisitStatus.completed && !v.date.isBefore(scheduleDate),
        2 => status == VisitStatus.completed,
        _ => sameDay,
      };
      return matches &&
          inTab &&
          (area == 'all' || v.area == area) &&
          (priority == 'all' || (priority == 'high') == v.highPriority);
    }).toList()..sort((a, b) {
      final byDate = a.date.compareTo(b.date);
      return byDate == 0 ? a.time.compareTo(b.time) : byDate;
    });
  }

  Inspection start(Visit visit) {
    if (!_restored) throw StateError('Restore drafts before starting a visit');
    if (!visits.any((v) => v.id == visit.id)) {
      throw ArgumentError('Unknown visit');
    }
    if (visit.status == VisitStatus.completed &&
        inspectionFor(visit.id) == null) {
      throw StateError('Completed sample visits cannot be restarted');
    }
    final inspection = _inspections.putIfAbsent(
      visit.id,
      () => Inspection(
        visitId: visit.id,
        reportNumber: (240 + visits.indexOf(visit)).toString().padLeft(4, '0'),
      ),
    );
    if (!inspection.submitted) inspection.startedAt ??= clock();
    notifyListeners();
    return inspection;
  }

  void toggleCheck(Inspection inspection, String id) {
    if (inspection.submitted) return;
    if (!inspection.checkedIds.remove(id)) inspection.checkedIds.add(id);
    notifyListeners();
  }

  String? validationError(Inspection inspection) {
    return policy.validate(inspection);
  }

  Future<bool> save(Inspection inspection, {bool submit = false}) async {
    if (busy ||
        !_restored ||
        !identical(_inspections[inspection.visitId], inspection)) {
      return false;
    }
    if (submit && validationError(inspection) != null) return false;
    busy = true;
    error = null;
    notifyListeners();
    final oldSubmitted = inspection.submittedAt;
    final oldSaved = inspection.savedAt;
    if (submit) inspection.submittedAt ??= clock();
    inspection.savedAt = clock();
    try {
      await store.save(reports);
      return true;
    } catch (_) {
      inspection.submittedAt = oldSubmitted;
      inspection.savedAt = oldSaved;
      error = 'save';
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<bool> addAttachment(Inspection inspection, {bool? camera}) async {
    if (busy || inspection.submitted) return false;
    busy = true;
    error = null;
    notifyListeners();
    try {
      if (inspection.attachments.length >= 6) {
        error = 'attachment_limit';
        return false;
      }
      final item = camera == null
          ? await attachments.pickDocument()
          : await attachments.pickPhoto(camera: camera);
      if (item == null) return false;
      inspection.attachments.add(item);
      return true;
    } catch (e) {
      error = e.toString().contains('attachment_too_large') ? 'size' : 'picker';
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void removeAttachment(Inspection inspection, String id) {
    if (inspection.submitted) return;
    inspection.attachments.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void changed() => notifyListeners();
  static bool sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
