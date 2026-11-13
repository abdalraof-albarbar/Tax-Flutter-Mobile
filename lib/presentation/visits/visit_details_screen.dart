import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/visit.dart';
import '../inspection/checklist_screen.dart';
import '../reports/report_details_screen.dart';
import '../widgets/demo_map.dart';
import '../widgets/feedback.dart';
import '../widgets/screen_frame.dart';
import '../widgets/status_badge.dart';
import '../widgets/surface.dart';
import 'business_facts.dart';

class VisitDetailsScreen extends StatelessWidget {
  const VisitDetailsScreen({super.key, required this.visit});
  final Visit visit;
  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final inspection = controller.inspectionFor(visit.id);
    final completed = controller.statusOf(visit) == VisitStatus.completed;
    return ScreenFrame(
      title: context.tr('تفاصيل الزيارة', 'Visit details'),
      actions: [
        IconButton(
          tooltip: context.tr('فتح الاتجاهات', 'Open directions'),
          onPressed: () => openDirections(context, visit),
          icon: const Icon(Icons.location_on_outlined),
        ),
        IconButton(
          tooltip: context.tr('نسخ بيانات الزيارة', 'Copy visit details'),
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(
                text: '${visit.name}\n${visit.taxNumber}\n${visit.area}',
              ),
            );
            if (context.mounted) {
              showMessage(
                context,
                'تم نسخ بيانات الزيارة',
                'Visit details copied',
              );
            }
          },
          icon: const Icon(Icons.share_outlined),
        ),
      ],
      child: PageBody(
        children: [
          Surface(
            child: Row(
              children: [
                const IconTile(Icons.apartment_outlined),
                const SizedBox(width: Space.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr(visit.name, visit.englishName),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        context.tr('زيارة ميدانية', 'Field inspection'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: Space.sm),
                      StatusBadge(
                        status: controller.statusOf(visit),
                        priority: visit.highPriority,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Space.lg),
          BusinessFacts(visit: visit),
          const SizedBox(height: Space.lg),
          Surface(
            child: Column(
              children: [
                SectionTitle(
                  context.tr('موقع النشاط', 'Business location'),
                  action: TextButton(
                    onPressed: () => openDirections(context, visit),
                    child: Text(context.tr('الاتجاهات', 'Directions')),
                  ),
                ),
                const DemoMap(),
              ],
            ),
          ),
          const SizedBox(height: Space.lg),
          Surface(
            child: Column(
              children: [
                StatusBadge(status: controller.statusOf(visit)),
                const SizedBox(height: Space.lg),
                Notice(
                  context.tr(
                    'يُسجّل وقت البدء محليًا؛ لا يقيس هذا النموذج GPS.',
                    'Start time is recorded locally; GPS is not measured in this demo.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Space.xl),
          FilledButton.icon(
            key: const ValueKey('start-visit'),
            onPressed: completed && inspection == null
                ? null
                : () {
                    if (inspection?.submitted ?? false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ReportDetailsScreen(inspection: inspection!),
                        ),
                      );
                    } else {
                      final draft = controller.start(visit);
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => ChecklistScreen(inspection: draft),
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.location_on_outlined),
            label: Text(
              completed
                  ? context.tr('عرض المحضر', 'View report')
                  : inspection == null
                  ? context.tr('بدء الزيارة', 'Start visit')
                  : context.tr('متابعة الزيارة', 'Continue visit'),
            ),
          ),
          if (completed && inspection == null)
            Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Text(
                context.tr(
                  'زيارة مكتملة ضمن البيانات التجريبية؛ لا يوجد محضر مرفق.',
                  'Completed sample visit; no report is attached.',
                ),
              ),
            ),
          TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  context.tr('الإقرارات السابقة', 'Previous declarations'),
                ),
                content: Text(
                  context.tr(
                    'لا تتوفر إقرارات سابقة في البيانات التجريبية.',
                    'No previous declarations in the sample data.',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.tr('إغلاق', 'Close')),
                  ),
                ],
              ),
            ),
            child: Text(
              context.tr('عرض الإقرارات السابقة', 'View previous declarations'),
            ),
          ),
        ],
      ),
    );
  }
}
