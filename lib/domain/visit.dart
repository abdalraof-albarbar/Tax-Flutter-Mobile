enum VisitStatus { scheduled, active, completed }

class Visit {
  const Visit({
    required this.id,
    required this.name,
    required this.englishName,
    required this.area,
    required this.englishArea,
    required this.taxNumber,
    required this.time,
    required this.date,
    required this.category,
    required this.englishCategory,
    required this.latitude,
    required this.longitude,
    this.durationMinutes = 90,
    this.highPriority = false,
    this.status = VisitStatus.scheduled,
  });
  final String id, name, englishName, area, englishArea, taxNumber, time;
  final String category, englishCategory;
  final DateTime date;
  final double latitude, longitude;
  final int durationMinutes;
  final bool highPriority;
  final VisitStatus status;

  static int compareSchedule(Visit first, Visit second) {
    final byDate = first.date.compareTo(second.date);
    if (byDate != 0) return byDate;
    return first.time.compareTo(second.time);
  }
}

class ChecklistItem {
  const ChecklistItem(this.id, this.arabic, this.english);
  final String id, arabic, english;
}

class NamedOption {
  const NamedOption(this.id, this.arabic, this.english);
  final String id, arabic, english;
}
