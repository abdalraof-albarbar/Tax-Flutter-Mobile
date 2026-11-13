import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/inspection.dart';
import '../reports/report_details_screen.dart';
import '../reports/report_summary.dart';
import '../widgets/feedback.dart';
import '../widgets/screen_frame.dart';
import '../widgets/surface.dart';
import 'attachment_panel.dart';
import 'draft_guard.dart';
import 'result_fields.dart';
import 'workflow_steps.dart';

class ReportPreviewScreen extends StatelessWidget {
  const ReportPreviewScreen({super.key, required this.inspection});
  final Inspection inspection;
  Future<void> _submit(BuildContext context) async {
    final controller = AppScope.of(context);
    final error = controller.validationError(inspection);
    if (error != null) {
      showMessage(
        context,
        error == 'findings'
            ? 'حدد نوع الملاحظة واكتب ملاحظات المفتش'
            : 'أكمل قائمة التحقق وحدد نتيجة المعاينة أولًا',
        error == 'findings'
            ? 'Select a finding type and add inspector notes'
            : 'Complete the checklist and select a result first',
      );
      return;
    }
    final ok = await controller.save(inspection, submit: true);
    if (!context.mounted) return;
    if (!ok) {
      showMessage(
        context,
        'تعذر الحفظ. لم يتم رفع المحضر؛ حاول مجددًا.',
        'Save failed. Report was not submitted; please retry.',
      );
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ReportDetailsScreen(inspection: inspection),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    return DraftGuard(
      inspection: inspection,
      child: ScreenFrame(
        title: context.tr('معاينة المحضر', 'Report preview'),
        subtitle: context.tr(
          'قبل الرفع للمراجعة',
          'Before submitting for review',
        ),
        bottom: Wrap(
          spacing: Space.md,
          runSpacing: Space.sm,
          alignment: WrapAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: controller.busy
                  ? null
                  : () => saveDraft(context, inspection),
              child: Text(context.tr('حفظ مسودة', 'Save draft')),
            ),
            FilledButton(
              key: const ValueKey('submit-report'),
              onPressed: controller.busy ? null : () => _submit(context),
              child: Text(
                context.tr('رفع تجريبي للمراجعة', 'Submit for demo review'),
              ),
            ),
          ],
        ),
        child: PageBody(
          children: [
            const WorkflowSteps(current: 2),
            SectionTitle(context.tr('ملخص الزيارة', 'Visit summary')),
            ReportSummary(inspection: inspection),
            ResultFields(inspection: inspection, showViolation: true),
            SectionTitle(context.tr('ملاحظات المفتش', 'Inspector notes')),
            TextFormField(
              initialValue: inspection.notes,
              minLines: 3,
              maxLines: 5,
              maxLength: 2000,
              decoration: InputDecoration(
                hintText: context.tr(
                  'وثّق نتيجة المعاينة…',
                  'Describe your findings…',
                ),
              ),
              onChanged: (value) => inspection.notes = value,
            ),
            SectionTitle(context.tr('المرفقات', 'Attachments')),
            Wrap(
              spacing: Space.md,
              runSpacing: Space.sm,
              children: [
                Chip(
                  avatar: const Icon(Icons.image_outlined),
                  label: Text(
                    '${inspection.photoCount} ${context.tr('صور', 'photos')}',
                  ),
                ),
                Chip(
                  avatar: const Icon(Icons.description_outlined),
                  label: Text(
                    '${inspection.documentCount} ${context.tr('مستندات', 'documents')}',
                  ),
                ),
                TextButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    builder: (context) => SafeArea(
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * .7,
                        child: ListView(
                          padding: const EdgeInsets.all(Space.lg),
                          children: [
                            AttachmentPanel(
                              inspection: inspection,
                              editable: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: Text(context.tr('عرض المرفقات', 'View attachments')),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            Notice(
              context.tr(
                'يمكن تعديل المسودة قبل إرسالها. الرفع هنا محلي تجريبي ولا يرسل إلى أي جهة.',
                'Edit your draft before submission. Demo submission stays on this device.',
              ),
              warning: true,
            ),
          ],
        ),
      ),
    );
  }
}
