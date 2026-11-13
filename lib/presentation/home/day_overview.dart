import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/component_style.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';

class DayOverview extends StatelessWidget {
  const DayOverview({super.key, required this.completed, required this.total});
  final int completed, total;
  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    final percent = '${(progress * 100).round()}%';
    return Container(
      decoration: ComponentTokens.overview,
      padding: const EdgeInsets.all(Space.xl),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = MediaQuery.textScalerOf(context).scale(1);
          final ring = SizedBox.square(
            dimension: math.min(
              ComponentTokens.ringSize * scale,
              constraints.maxWidth,
            ),
            child: Semantics(
              label: context.tr(
                'إنجاز اليوم $percent',
                'Today’s progress $percent',
              ),
              child: ExcludeSemantics(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: ComponentTokens.ringStroke,
                        color: Palette.white,
                        backgroundColor: ComponentTokens.onTealTrack,
                      ),
                    ),
                    Text(
                      percent,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: Palette.white),
                    ),
                  ],
                ),
              ),
            ),
          );
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('إنجاز اليوم', 'Today’s progress'),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Palette.white),
              ),
              const SizedBox(height: Space.sm),
              Text(
                context.tr(
                  'أنجزت $completed من $total زيارات',
                  '$completed of $total visits completed',
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ComponentTokens.onTealMuted,
                ),
              ),
              const SizedBox(height: Space.lg),
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [
                  _ProgressStat('$completed ${context.tr('مكتملة', 'done')}'),
                  _ProgressStat(
                    '${total - completed} ${context.tr('متبقية', 'remaining')}',
                  ),
                ],
              ),
            ],
          );
          if (constraints.maxWidth >= ComponentTokens.summaryRowWidth * scale) {
            return Row(
              children: [
                Expanded(child: copy),
                const SizedBox(width: Space.xl),
                ring,
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              copy,
              const SizedBox(height: Space.xl),
              ring,
            ],
          );
        },
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  const _ProgressStat(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: Space.md,
      vertical: Space.sm,
    ),
    decoration: ComponentTokens.stat,
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(color: Palette.white),
    ),
  );
}
