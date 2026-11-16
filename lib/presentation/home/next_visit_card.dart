// Adapted from Flutter Authors' animations OpenContainer example (BSD-3-Clause).
// Changes: inspection data, responsive metadata, RTL, and reduced-motion timing.
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import '../../core/component_style.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/visit.dart';
import '../visits/visit_details_screen.dart';
import '../widgets/status_badge.dart';
import '../widgets/surface.dart';

class NextVisitCard extends StatelessWidget {
  const NextVisitCard({super.key, required this.visit});
  final Visit visit;
  @override
  Widget build(BuildContext context) => OpenContainer<void>(
    transitionDuration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : ComponentTokens.containerDuration,
    closedElevation: 0,
    openElevation: 0,
    closedShape: ComponentTokens.cardShape,
    closedColor: Palette.white,
    openColor: Palette.background,
    tappable: false,
    openBuilder: (_, _) => VisitDetailsScreen(visit: visit),
    closedBuilder: (context, open) => Padding(
      padding: const EdgeInsets.all(Space.xl),
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
          const SizedBox(height: Space.lg),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              if (visit.highPriority) const StatusBadge(priority: true),
              _VisitFact(Icons.schedule_rounded, visit.time),
              _VisitFact(
                Icons.location_on_outlined,
                context.tr(visit.area, visit.englishArea),
              ),
            ],
          ),
          const SizedBox(height: Space.xl),
          FilledButton.icon(
            key: const ValueKey('next-visit'),
            onPressed: open,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(context.tr('عرض الزيارة', 'View visit')),
          ),
        ],
      ),
    ),
  );
}

class _VisitFact extends StatelessWidget {
  const _VisitFact(this.icon, this.value);
  final IconData icon;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: Space.md,
      vertical: Space.sm,
    ),
    decoration: BoxDecoration(
      color: Palette.background,
      borderRadius: BorderRadius.circular(Space.controlRadius),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: Space.lg, color: Palette.deepTeal),
        const SizedBox(width: Space.xs),
        Flexible(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    ),
  );
}
