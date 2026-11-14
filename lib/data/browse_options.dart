import '../domain/browse_choice.dart';
import '../domain/essential_content.dart';
import '../domain/visit.dart';

abstract final class BrowseOptions {
  static const defaultAreas = <NamedOption>[NamedOption('all', 'الكل', 'All')];
  static const visitTabs = <BrowseChoice<VisitListTab>>[
    BrowseChoice(VisitListTab.today, BilingualText('اليوم', 'Today')),
    BrowseChoice(VisitListTab.upcoming, BilingualText('القادمة', 'Upcoming')),
    BrowseChoice(
      VisitListTab.completed,
      BilingualText('المكتملة', 'Completed'),
    ),
  ];
  static const visitOrders = <BrowseChoice<VisitOrder>>[
    BrowseChoice(
      VisitOrder.schedule,
      BilingualText('حسب الموعد', 'By schedule'),
    ),
    BrowseChoice(
      VisitOrder.priority,
      BilingualText('الأولوية أولًا', 'Priority first'),
    ),
  ];
  static const reportFilters = <BrowseChoice<ReportListFilter>>[
    BrowseChoice(ReportListFilter.all, BilingualText('الكل', 'All')),
    BrowseChoice(ReportListFilter.drafts, BilingualText('المسودات', 'Drafts')),
    BrowseChoice(
      ReportListFilter.review,
      BilingualText('مرفوعة تجريبيًا', 'Demo submitted'),
    ),
  ];
}
