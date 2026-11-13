import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../app/app_scope.dart';
import '../../app/navigation_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/inspection.dart';
import '../inspection/attachment_panel.dart';
import '../visits/visit_details_screen.dart';
import '../widgets/feedback.dart';
import '../widgets/screen_frame.dart';
import '../widgets/surface.dart';
import 'report_summary.dart';
import 'report_timeline.dart';

class ReportDetailsScreen extends StatelessWidget {
  const ReportDetailsScreen({super.key, required this.inspection});
  final Inspection inspection;
  @override
  Widget build(BuildContext context) {
    final visit = AppScope.of(context).visitFor(inspection.visitId);
    final code = 'DEMO-V-${inspection.reportNumber}';
    return ScreenFrame(
      title: context.tr('تفاصيل المحضر', 'Report details'),
      child: PageBody(
        children: [
          Notice(
            context.tr(
              'تم حفظ المحضر التجريبي • قيد المراجعة محليًا',
              'Demo report saved • Local review status',
            ),
          ),
          const SizedBox(height: Space.lg),
          ReportSummary(inspection: inspection, includeInspector: true),
          const SizedBox(height: Space.xl),
          Center(
            child: Surface(
              padding: Space.sm,
              child: Semantics(
                label: code,
                child: QrImageView(
                  data: code,
                  size: Space.qr,
                  backgroundColor: Palette.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: Space.sm),
          Text(
            context.tr('رمز المحضر', 'Report code'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            code,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: code));
                if (context.mounted) {
                  showMessage(
                    context,
                    'تم نسخ رمز المحضر',
                    'Report code copied',
                  );
                }
              },
              icon: const Icon(Icons.copy_outlined),
              label: Text(context.tr('نسخ رمز المحضر', 'Copy report code')),
            ),
          ),
          const SizedBox(height: Space.lg),
          ReportTimeline(inspection: inspection),
          const SizedBox(height: Space.lg),
          Surface(
            padding: Space.xs,
            child: Column(
              children: [
                ListTile(
                  leading: const IconTile(Icons.attach_file),
                  title: Text(context.tr('عرض المرفقات', 'View attachments')),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    builder: (context) => SafeArea(
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * .75,
                        child: ListView(
                          padding: const EdgeInsets.all(Space.lg),
                          children: [
                            AttachmentPanel(
                              inspection: inspection,
                              editable: false,
                            ),
                            Text(inspection.attachmentNotes),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const IconTile(Icons.assignment_outlined),
                  title: Text(
                    context.tr('عرض تفاصيل الزيارة', 'View visit details'),
                  ),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => VisitDetailsScreen(visit: visit),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SectionTitle(context.tr('النتيجة والملاحظات', 'Result and notes')),
          Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inspection.hasFindings == true
                      ? context.tr('توجد ملاحظات', 'Findings recorded')
                      : context.tr('لا توجد ملاحظات', 'No findings'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (inspection.notes.isNotEmpty) Text(inspection.notes),
              ],
            ),
          ),
          const SizedBox(height: Space.lg),
          FilledButton(
            key: const ValueKey('return-reports'),
            onPressed: () {
              NavigationScope.maybeOf(context)?.selectTab(2);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text(
              context.tr('العودة إلى محاضري', 'Return to my reports'),
            ),
          ),
        ],
      ),
    );
  }
}
