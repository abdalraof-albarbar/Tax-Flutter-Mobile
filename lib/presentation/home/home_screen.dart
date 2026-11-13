import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';
import '../../domain/visit.dart';
import '../visits/route_sheet.dart';
import '../widgets/demo_map.dart';
import '../widgets/screen_frame.dart';
import '../widgets/surface.dart';
import '../widgets/visit_tile.dart';
import 'day_overview.dart';
import 'next_visit_card.dart';
import 'dashboard_shortcuts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onShowVisits});
  final VoidCallback onShowVisits;
  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final today = controller.filtered(date: SampleData.date);
    final completed = today
        .where((v) => controller.statusOf(v) == VisitStatus.completed)
        .length;
    final pending = today
        .where((v) => controller.statusOf(v) != VisitStatus.completed)
        .toList();
    return PageBody(
      children: [
        Text(
          MaterialLocalizations.of(context).formatFullDate(SampleData.date),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: Space.md),
        Text(
          context.tr(
            'صباح الخير، ${SampleData.inspector[0].split(' ').first}',
            'Good morning, ${SampleData.inspector[1].split(' ').first}',
          ),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          context.tr(
            'عندك ${today.length} زيارات اليوم',
            '${today.length} visits on your schedule',
          ),
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Palette.muted),
        ),
        const SizedBox(height: Space.xl),
        DayOverview(completed: completed, total: today.length),
        SectionTitle(context.tr('الزيارة القادمة', 'Next visit')),
        if (pending.isEmpty)
          Notice(
            context.tr('أكملت جميع زيارات اليوم', 'All visits completed today'),
          )
        else
          NextVisitCard(visit: pending.first),
        const SizedBox(height: Space.xl),
        DashboardShortcuts(visits: today, onShowVisits: onShowVisits),
        const SizedBox(height: Space.lg),
        SectionTitle(
          context.tr('جدول اليوم', 'Today’s schedule'),
          action: TextButton(
            onPressed: onShowVisits,
            child: Text(context.tr('عرض الكل', 'View all')),
          ),
        ),
        Surface(
          child: Column(
            children: [
              for (var i = 0; i < today.take(2).length; i++) ...[
                if (i > 0) const Divider(),
                VisitTile(today[i]),
              ],
            ],
          ),
        ),
        const SizedBox(height: Space.lg),
        InkWell(
          onTap: () => showRouteSheet(context, today),
          borderRadius: BorderRadius.circular(Space.radius),
          child: Surface(
            child: Column(
              children: [
                Row(
                  children: [
                    const IconTile(Icons.map_outlined),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: Text(
                        context.tr(
                          'عرض المسار على الخريطة',
                          'View today’s route',
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Palette.teal,
                    ),
                  ],
                ),
                const SizedBox(height: Space.md),
                const DemoMap(route: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
