import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/inspection.dart';
import '../widgets/feedback.dart';
import '../widgets/screen_frame.dart';
import '../widgets/surface.dart';
import 'attachment_panel.dart';
import 'draft_guard.dart';
import 'report_preview_screen.dart';
import 'workflow_steps.dart';

class AttachmentsScreen extends StatelessWidget {
  const AttachmentsScreen({super.key, required this.inspection});
  final Inspection inspection;
  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final visit = controller.visitFor(inspection.visitId);
    return DraftGuard(
      inspection: inspection,
      child: ScreenFrame(
        title: context.tr('المرفقات', 'Attachments'),
        subtitle: context.tr(visit.name, visit.englishName),
        bottom: Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: Space.md,
          runSpacing: Space.sm,
          children: [
            TextButton(
              onPressed: controller.busy
                  ? null
                  : () => saveDraft(context, inspection),
              child: Text(context.tr('حفظ مسودة', 'Save draft')),
            ),
            FilledButton(
              key: const ValueKey('next-report'),
              onPressed: controller.busy
                  ? null
                  : () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ReportPreviewScreen(inspection: inspection),
                      ),
                    ),
              child: Text(context.tr('التالي: المحضر', 'Next: report')),
            ),
          ],
        ),
        child: PageBody(
          children: [
            const WorkflowSteps(current: 1),
            Notice(
              context.tr(
                'الموقع: ${visit.area} • موقع النشاط التجريبي؛ GPS غير مقاس',
                'Location: ${visit.englishArea} • Sample business location; GPS not measured',
              ),
            ),
            AttachmentPanel(inspection: inspection),
            const Divider(height: Space.xxl),
            SectionTitle(
              context.tr('ملاحظات على المرفقات', 'Attachment notes'),
            ),
            TextFormField(
              initialValue: inspection.attachmentNotes,
              maxLines: 4,
              minLines: 3,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: context.tr(
                  'أضف وصفًا مختصرًا…',
                  'Add a short description…',
                ),
              ),
              onChanged: (value) => inspection.attachmentNotes = value,
            ),
          ],
        ),
      ),
    );
  }
}
