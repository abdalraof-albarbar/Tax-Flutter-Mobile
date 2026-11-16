import 'package:flutter/foundation.dart';
import '../domain/browse_choice.dart';
import '../domain/visit.dart';
import 'inspection_controller.dart';

/// Session-only browsing state; never changes visit records or persisted drafts.
class VisitBrowserController extends ChangeNotifier {
  VisitBrowserController({required this.scheduleDate}) : date = scheduleDate;
  final DateTime scheduleDate;
  DateTime date;
  VisitListTab tab = VisitListTab.today;
  VisitOrder order = VisitOrder.schedule;
  String query = '', area = 'all', priority = 'all';
  int get activeFilterCount =>
      (area == 'all' ? 0 : 1) +
      (priority == 'all' ? 0 : 1) +
      (order == VisitOrder.schedule ? 0 : 1);

  bool get isFiltered =>
      query.isNotEmpty ||
      area != 'all' ||
      priority != 'all' ||
      order != VisitOrder.schedule ||
      tab != VisitListTab.today ||
      !InspectionController.sameDate(date, scheduleDate);
  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void setTab(VisitListTab value) {
    tab = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  void setArea(String value) {
    area = value;
    notifyListeners();
  }

  void setPriority(String value) {
    priority = value;
    notifyListeners();
  }

  void setOrder(VisitOrder value) {
    order = value;
    notifyListeners();
  }

  void applyFilters({
    required String area,
    required String priority,
    required VisitOrder order,
  }) {
    this.area = area;
    this.priority = priority;
    this.order = order;
    notifyListeners();
  }

  void reset() {
    query = '';
    area = 'all';
    priority = 'all';
    date = scheduleDate;
    tab = VisitListTab.today;
    order = VisitOrder.schedule;
    notifyListeners();
  }

  List<Visit> results(InspectionController inspections) {
    final visits = inspections.filtered(
      query: query,
      area: area,
      priority: priority,
      date: date,
      tab: tab.index,
    );
    if (order == VisitOrder.priority) {
      visits.sort((first, second) {
        if (first.highPriority != second.highPriority) {
          return first.highPriority ? -1 : 1;
        }
        return Visit.compareSchedule(first, second);
      });
    }
    return List.unmodifiable(visits);
  }
}
