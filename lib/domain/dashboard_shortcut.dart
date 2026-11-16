import 'essential_content.dart';

enum DashboardAction { visits, reports, help, route }

class DashboardShortcut {
  const DashboardShortcut(this.action, this.label);
  final DashboardAction action;
  final BilingualText label;
}
