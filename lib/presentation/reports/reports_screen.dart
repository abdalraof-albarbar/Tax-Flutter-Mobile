import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../inspection/checklist_screen.dart';
import '../widgets/screen_frame.dart';
import '../widgets/surface.dart';
import 'report_details_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final reports = controller.reports.reversed.toList();
    return PageBody(
      children: [
        SectionTitle(context.tr('محاضري', 'My reports')),
        if (reports.isEmpty)
          Surface(
            child: Column(
              children: [
                const IconTile(Icons.assignment_outlined),
                const SizedBox(height: Space.lg),
                Text(
                  context.tr('لا توجد محاضر بعد', 'No reports yet'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  context.tr(
                    'ابدأ زيارة لإنشاء أول مسودة',
                    'Start a visit to create your first draft',
                  ),
                ),
              ],
            ),
          ),
        for (final inspection in reports)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.md),
            child: Surface(
              padding: Space.sm,
              child: ListTile(
                leading: const IconTile(Icons.description_outlined),
                title: Text(
                  context.tr(
                    controller.visitFor(inspection.visitId).name,
                    controller.visitFor(inspection.visitId).englishName,
                  ),
                ),
                subtitle: Text(
                  '${inspection.reportNumber} • ${inspection.submitted ? context.tr('قيد المراجعة • تجريبي', 'Under review • Demo') : context.tr('مسودة', 'Draft')}',
                ),
                trailing: const Icon(Icons.chevron_left),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => inspection.submitted
                        ? ReportDetailsScreen(inspection: inspection)
                        : ChecklistScreen(inspection: inspection),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
