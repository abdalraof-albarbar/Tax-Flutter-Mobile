import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/app_page_route.dart';
import '../../core/browse_style.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/visit.dart';
import '../widgets/status_badge.dart';
import 'visit_details_screen.dart';

class VisitScheduleCard extends StatelessWidget {
  const VisitScheduleCard({
    super.key,
    required this.visit,
    this.showDate = false,
  });
  final Visit visit;
  final bool showDate;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Space.md),
    child: Material(
      color: Palette.white,
      shape: BrowseTokens.shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('scheduled-visit-${visit.id}'),
        onTap: () =>
            openAppPage<void>(context, VisitDetailsScreen(visit: visit)),
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: Space.md,
                runSpacing: Space.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    visit.time,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Palette.deepTeal,
                    ),
                  ),
                  StatusBadge(status: AppScope.of(context).statusOf(visit)),
                  if (visit.highPriority) const StatusBadge(priority: true),
                ],
              ),
              const SizedBox(height: Space.md),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr(visit.name, visit.englishName),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(width: Space.sm),
                  Icon(
                    context.isArabic
                        ? Icons.chevron_left_rounded
                        : Icons.chevron_right_rounded,
                    color: Palette.deepTeal,
                  ),
                ],
              ),
              const SizedBox(height: Space.sm),
              Wrap(
                spacing: Space.md,
                runSpacing: Space.xs,
                children: [
                  Text(
                    context.tr(visit.area, visit.englishArea),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (showDate)
                    Text(
                      MaterialLocalizations.of(
                        context,
                      ).formatMediumDate(visit.date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
