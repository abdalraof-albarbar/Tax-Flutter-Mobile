import '../domain/dashboard_shortcut.dart';
import '../domain/essential_content.dart';

abstract final class DashboardOptions {
  static const shortcuts = <DashboardShortcut>[
    DashboardShortcut(
      DashboardAction.visits,
      BilingualText('جدول الزيارات', 'Visit schedule'),
    ),
    DashboardShortcut(
      DashboardAction.reports,
      BilingualText('سجل المحاضر', 'Report records'),
    ),
    DashboardShortcut(DashboardAction.help, BilingualText('المساعدة', 'Help')),
    DashboardShortcut(
      DashboardAction.route,
      BilingualText('مسار اليوم', 'Today’s route'),
    ),
  ];
}
