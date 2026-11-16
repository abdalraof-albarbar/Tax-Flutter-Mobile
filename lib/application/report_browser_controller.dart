import 'package:flutter/foundation.dart';
import '../domain/browse_choice.dart';
import '../domain/inspection.dart';
import 'inspection_controller.dart';

class ReportBrowserController extends ChangeNotifier {
  String query = '';
  ReportListFilter filter = ReportListFilter.all;
  bool get isFiltered => query.isNotEmpty || filter != ReportListFilter.all;
  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void setFilter(ReportListFilter value) {
    filter = value;
    notifyListeners();
  }

  void reset() {
    query = '';
    filter = ReportListFilter.all;
    notifyListeners();
  }

  List<Inspection> results(InspectionController inspections) {
    final term = query.trim().toLowerCase();
    final results = <Inspection>[];
    for (final report in inspections.reports.reversed) {
      if (!_matchesFilter(report)) continue;
      final visit = inspections.visitFor(report.visitId);
      final searchableText =
          '${visit.name} ${visit.englishName} ${visit.taxNumber} '
          '${report.reportNumber} #${report.reportNumber} '
          'DEMO-V-${report.reportNumber}';
      if (searchableText.toLowerCase().contains(term)) results.add(report);
    }
    return results.toList(growable: false);
  }

  bool _matchesFilter(Inspection report) => switch (filter) {
    ReportListFilter.all => true,
    ReportListFilter.drafts => !report.submitted,
    ReportListFilter.review => report.submitted,
  };
}
