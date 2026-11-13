import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/visit.dart';
import '../visits/visit_details_screen.dart';
import 'status_badge.dart';
import 'surface.dart';

class VisitTile extends StatelessWidget {
  const VisitTile(this.visit, {super.key, this.compact = false});
  final Visit visit;
  final bool compact;
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(Space.controlRadius),
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => VisitDetailsScreen(visit: visit)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.md),
      child: Row(
        children: [
          if (!compact) ...[
            IconTile(
              visit.category == 'مكتبة'
                  ? Icons.menu_book_outlined
                  : Icons.storefront_outlined,
            ),
            const SizedBox(width: Space.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(visit.name, visit.englishName),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Wrap(
                  spacing: Space.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: Space.lg,
                      color: Palette.muted,
                    ),
                    Text(
                      visit.time,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      context.tr(visit.area, visit.englishArea),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.sm),
          Flexible(
            child: StatusBadge(status: AppScope.of(context).statusOf(visit)),
          ),
        ],
      ),
    ),
  );
}
