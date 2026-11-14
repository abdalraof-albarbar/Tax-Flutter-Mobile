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
    return List.unmodifiable(
      groups.values
          .where((items) {
            return items.any(
              (v) =>
                  '${v.name} ${v.englishName} ${v.area} '
                          '${v.englishArea} ${v.taxNumber}'
                      .toLowerCase()
                      .contains(term),
            );
          })
          .map(
            (items) => Business(
              [...items]..sort((a, b) {
                final day = a.date.compareTo(b.date);
                return day == 0 ? a.time.compareTo(b.time) : day;
              }),
            ),
          ),
    );
  }
}
