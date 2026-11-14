import 'visit.dart';

/// A read-only projection of existing sample visits, grouped by tax number.
class Business {
  Business(List<Visit> visits) : visits = List.unmodifiable(visits);
  final List<Visit> visits;
  Visit get primary => visits.first;
  String get taxNumber => primary.taxNumber;
  static List<Business> fromVisits(List<Visit> visits, {String query = ''}) {
    final groups = <String, List<Visit>>{};
    for (final visit in visits) {
      groups.putIfAbsent(visit.taxNumber, () => []).add(visit);
    }
    final term = query.trim().toLowerCase();
    final businesses = <Business>[];
    for (final group in groups.values) {
      if (!group.any((visit) => _matchesSearch(visit, term))) continue;
      final scheduledVisits = [...group]..sort(Visit.compareSchedule);
      businesses.add(Business(scheduledVisits));
    }
    return List.unmodifiable(businesses);
  }

  static bool _matchesSearch(Visit visit, String term) {
    final searchableText =
        '${visit.name} ${visit.englishName} ${visit.area} '
        '${visit.englishArea} ${visit.taxNumber}';
    return searchableText.toLowerCase().contains(term);
  }
}
