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
    return inspections.reports.reversed
        .where((report) {
          final visit = inspections.visitFor(report.visitId);
          final matches =
              '${visit.name} ${visit.englishName} ${visit.taxNumber} '
                      '${report.reportNumber}'
                  .toLowerCase()
                  .contains(term);
          return matches &&
              switch (filter) {
                ReportListFilter.all => true,
                ReportListFilter.drafts => !report.submitted,
                ReportListFilter.review => report.submitted,
              };
        })
        .toList(growable: false);
  }
}
