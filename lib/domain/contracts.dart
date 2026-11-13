import 'inspection.dart';
import 'visit.dart';

abstract interface class VisitRepository {
  List<Visit> get visits;
}

abstract interface class DraftStore {
  Future<List<Inspection>> load();
  Future<void> save(List<Inspection> inspections);
}

abstract interface class AttachmentService {
  Future<InspectionAttachment?> pickPhoto({required bool camera});
  Future<InspectionAttachment?> pickDocument();
}

abstract interface class DirectionsService {
  Future<bool> open(Visit visit);
}
