import 'package:flutter/material.dart';
import '../../app/navigation_scope.dart';
import '../../core/app_page_route.dart';
import '../../core/component_style.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/dashboard_options.dart';
import '../../domain/dashboard_shortcut.dart';
import '../../domain/visit.dart';
import '../essentials/help_screen.dart';
import '../visits/route_sheet.dart';

class DashboardShortcuts extends StatelessWidget {
  const DashboardShortcuts({
    super.key,
    required this.visits,
    required this.onShowVisits,
  });
  final List<Visit> visits;
  final VoidCallback onShowVisits;
  void open(BuildContext context, DashboardAction action) {
    switch (action) {
      case DashboardAction.visits:
        onShowVisits();
      case DashboardAction.reports:
        NavigationScope.maybeOf(context)?.selectTab(2);
      case DashboardAction.help:
        openAppPage<void>(context, const HelpScreen());
      case DashboardAction.route:
        showRouteSheet(context, visits);
    }
  }

  IconData icon(DashboardAction action) => switch (action) {
    DashboardAction.visits => Icons.calendar_month_outlined,
    DashboardAction.reports => Icons.assignment_outlined,
    DashboardAction.help => Icons.help_outline_rounded,
    DashboardAction.route => Icons.route_outlined,
  };
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(1);
      final columns =
          constraints.maxWidth < ComponentTokens.shortcutStacked ||
              scale >= ComponentTokens.enlargedText
          ? 1
          : constraints.maxWidth >= ComponentTokens.shortcutWide
          ? 4
          : 2;
      final width = (constraints.maxWidth - Space.md * (columns - 1)) / columns;
      return Wrap(
        spacing: Space.md,
        runSpacing: Space.md,
        children: [
          for (final shortcut in DashboardOptions.shortcuts)
            SizedBox(
              width: width,
              child: Material(
                color: Palette.white,
                shape: ComponentTokens.cardShape,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  key: ValueKey('shortcut-${shortcut.action.name}'),
                  onTap:
                      shortcut.action == DashboardAction.reports &&
                          NavigationScope.maybeOf(context) == null
                      ? null
                      : () => open(context, shortcut.action),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: ComponentTokens.shortcutHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Space.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            icon(shortcut.action),
                            color: Palette.deepTeal,
                            size: ComponentTokens.shortcutIcon,
                          ),
                          const SizedBox(height: Space.sm),
                          Text(
                            shortcut.label.text(context.isArabic),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}
