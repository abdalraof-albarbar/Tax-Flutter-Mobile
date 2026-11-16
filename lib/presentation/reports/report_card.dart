import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/app_page_route.dart';
import '../../core/browse_style.dart';
import '../../core/localization.dart';
import '../../core/record_count.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';
import '../../domain/inspection.dart';
import '../inspection/checklist_screen.dart';
import 'report_details_screen.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.inspection});
  final Inspection inspection;

  String _statusLabel(BuildContext context) {
    if (inspection.submitted) {
      return context.tr('قيد المراجعة • تجريبي', 'Under review • Demo');
    }
    if (inspection.savedAt == null) {
      return context.tr('مسودة غير محفوظة', 'Unsaved draft');
    }
    return context.tr('مسودة', 'Draft');
  }

  @override
  Widget build(BuildContext context) {
    final visit = AppScope.of(context).visitFor(inspection.visitId);
    final completed = SampleData.checklist
        .where((item) => inspection.checkedIds.contains(item.id))
        .length;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Material(
        color: Palette.white,
        shape: BrowseTokens.shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('report-${inspection.visitId}'),
          onTap: () => openAppPage<void>(
            context,
            inspection.submitted
                ? ReportDetailsScreen(inspection: inspection)
                : ChecklistScreen(inspection: inspection),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: Space.md,
                  runSpacing: Space.sm,
                  children: [
                    Text(
                      '#${inspection.reportNumber}',
                      textDirection: TextDirection.ltr,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      _statusLabel(context),
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Palette.deepTeal),
                    ),
                  ],
                ),
                const SizedBox(height: Space.md),
                Text(
                  context.tr(visit.name, visit.englishName),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(context.tr(visit.area, visit.englishArea)),
                const SizedBox(height: Space.md),
                if (!inspection.submitted) ...[
                  Text(
                    context.tr(
                      'بنود التحقق $completed من ${SampleData.checklist.length}',
                      '$completed of ${SampleData.checklist.length} checks completed',
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: Space.sm),
                  LinearProgressIndicator(
                    value: SampleData.checklist.isEmpty
                        ? 0
                        : completed / SampleData.checklist.length,
                    backgroundColor: Palette.mint,
                    color: Palette.deepTeal,
                  ),
                  const SizedBox(height: Space.md),
                ],
                Wrap(
                  spacing: Space.md,
                  runSpacing: Space.sm,
                  children: [
                    Text(
                      RecordCount.attachments(
                        context,
                        inspection.attachments.length,
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      inspection.submitted
                          ? context.tr('عرض المحضر', 'View report')
                          : context.tr('متابعة المسودة', 'Continue draft'),
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Palette.deepTeal),
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
}
