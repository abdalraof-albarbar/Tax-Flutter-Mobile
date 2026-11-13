import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';
import '../../domain/inspection.dart';
import '../widgets/surface.dart';

class ReportSummary extends StatelessWidget {
  const ReportSummary({
    super.key,
    required this.inspection,
    this.includeInspector = false,
  });
  final Inspection inspection;
  final bool includeInspector;
  @override
  Widget build(BuildContext context) {
    final visit = AppScope.of(context).visitFor(inspection.visitId);
    final start = inspection.startedAt;
    final rows = [
      (context.tr('رقم المحضر', 'Report number'), inspection.reportNumber),
      (
        context.tr('تاريخ الزيارة', 'Visit date'),
        MaterialLocalizations.of(context).formatMediumDate(visit.date),
      ),
      (
        context.tr('وقت البدء', 'Started at'),
        start == null
            ? '—'
            : MaterialLocalizations.of(
                context,
              ).formatTimeOfDay(TimeOfDay.fromDateTime(start)),
      ),
      (
        context.tr('المنطقة', 'Area'),
        context.tr(visit.area, visit.englishArea),
      ),
      if (includeInspector)
        (
          context.tr('المفتش', 'Inspector'),
          context.tr(SampleData.inspector[0], SampleData.inspector[1]),
        ),
      (
        context.tr('الحالة', 'Status'),
        inspection.submitted
            ? context.tr('قيد المراجعة • تجريبي', 'Under review • Demo')
            : context.tr('مسودة', 'Draft'),
      ),
    ];
    return Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconTile(Icons.storefront_outlined),
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
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      rows[i].$1,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: Space.sm),
                  Flexible(
                    child: Text(
                      rows[i].$2,
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
