import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/visit.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, this.status, this.priority = false, this.text});
  final VisitStatus? status;
  final bool priority;
  final String? text;
  @override
  Widget build(BuildContext context) {
    final completed = status == VisitStatus.completed;
    final color = priority
        ? Palette.amber
        : completed
        ? Palette.green
        : Palette.deepTeal;
    final label =
        text ??
        (priority
            ? context.tr('أولوية مرتفعة', 'High priority')
            : switch (status) {
                VisitStatus.completed => context.tr('مكتملة', 'Completed'),
                VisitStatus.active => context.tr('زيارة جارية', 'In progress'),
                _ => context.tr('مجدولة', 'Scheduled'),
              });
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.md,
        vertical: Space.xs,
      ),
      decoration: BoxDecoration(
        color: priority
            ? Palette.amberLight
            : completed
            ? Palette.greenLight
            : Palette.mint,
        borderRadius: BorderRadius.circular(Space.controlRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priority
                ? Icons.flag_outlined
                : completed
                ? Icons.check_circle_outline
                : Icons.schedule_outlined,
            size: Space.lg,
            color: color,
          ),
          const SizedBox(width: Space.xs),
          Flexible(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
