import 'essential_content.dart';

enum VisitListTab { today, upcoming, completed }

enum VisitOrder { schedule, priority }

enum ReportListFilter { all, drafts, review }

class BrowseChoice<T> {
  const BrowseChoice(this.value, this.label);
  final T value;
  final BilingualText label;
}
