import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';
import '../../domain/visit.dart';
import '../visits/visit_details_screen.dart';
import '../visits/route_sheet.dart';
import '../widgets/demo_map.dart';
import '../widgets/screen_frame.dart';
import '../widgets/status_badge.dart';
import '../widgets/surface.dart';
import '../widgets/visit_tile.dart';

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
    final progress = today.isEmpty ? 0.0 : completed / today.length;
    return PageBody(
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            MaterialLocalizations.of(context).formatFullDate(SampleData.date),
            style: Theme.of(context).textTheme.bodySmall,
          ),
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
        Surface(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(
                        'أنجزت $completed من ${today.length} زيارات',
                        '$completed of ${today.length} visits completed',
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: Space.lg),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Space.controlRadius),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: Space.sm,
                        backgroundColor: Palette.border,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Space.xl),
              SizedBox(
                width: Space.touch + Space.lg,
                height: Space.touch + Space.lg,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: Space.sm,
                        backgroundColor: Palette.border,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SectionTitle(context.tr('الزيارة القادمة', 'Next visit')),
        if (pending.isEmpty)
          Notice(
            context.tr('أكملت جميع زيارات اليوم', 'All visits completed today'),
          )
        else
          _NextVisit(pending.first),
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
                    const Icon(Icons.chevron_left, color: Palette.teal),
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

class _NextVisit extends StatelessWidget {
  const _NextVisit(this.visit);
  final Visit visit;
  @override
  Widget build(BuildContext context) => Surface(
    color: Palette.mint,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const IconTile(Icons.apartment_outlined),
            const SizedBox(width: Space.md),
            Expanded(
              child: Text(
                context.tr(visit.name, visit.englishName),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.md),
        Wrap(
          spacing: Space.sm,
          runSpacing: Space.sm,
          children: [
            if (visit.highPriority) const StatusBadge(priority: true),
            Text(
              '${visit.time}  •  ${context.tr(visit.area, visit.englishArea)}',
            ),
          ],
        ),
        const SizedBox(height: Space.lg),
        FilledButton.icon(
          key: const ValueKey('next-visit'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => VisitDetailsScreen(visit: visit),
            ),
          ),
          icon: const Icon(Icons.arrow_forward),
          label: Text(context.tr('عرض الزيارة', 'View visit')),
        ),
      ],
    ),
  );
}
