import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';
import '../../domain/inspection.dart';
import '../widgets/feedback.dart';
import '../widgets/screen_frame.dart';
import '../widgets/surface.dart';
import 'attachments_screen.dart';
import 'draft_guard.dart';
import 'result_fields.dart';
import 'workflow_steps.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key, required this.inspection});
  final Inspection inspection;
  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final visit = controller.visitFor(inspection.visitId);
    return DraftGuard(
      inspection: inspection,
      child: ScreenFrame(
        title: context.tr('قائمة التحقق', 'Inspection checklist'),
        subtitle: context.tr(visit.name, visit.englishName),
        bottom: Wrap(
          spacing: Space.lg,
          runSpacing: Space.sm,
          alignment: WrapAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: controller.busy
                  ? null
                  : () => saveDraft(context, inspection),
              child: Text(context.tr('حفظ مسودة', 'Save draft')),
            ),
            FilledButton(
              key: const ValueKey('next-attachments'),
              onPressed: controller.busy
                  ? null
                  : () {
                      final checked = SampleData.checklist.every(
                        (i) => inspection.checkedIds.contains(i.id),
                      );
                      if (!checked || inspection.hasFindings == null) {
                        showMessage(
                          context,
                          'أكمل بنود المعاينة وحدد النتيجة أولًا',
                          'Complete the checklist and select a result first',
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              AttachmentsScreen(inspection: inspection),
                        ),
                      );
                    },
              child: Text(context.tr('التالي: المرفقات', 'Next: attachments')),
            ),
          ],
        ),
        child: PageBody(
          children: [
            const WorkflowSteps(current: 0),
            Notice(
              context.tr(
                'الزيارة جارية • وقت البدء مسجّل محليًا',
                'Visit in progress • Start time recorded locally',
              ),
            ),
            SectionTitle(context.tr('بنود المعاينة', 'Inspection items')),
            Text(
              context.tr(
                'عناصر تجريبية تُضبط وفق النموذج المعتمد',
                'Sample items; configure to match your approved form',
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: Space.lg),
            Surface(
              padding: Space.xs,
              child: Column(
                children: [
                  for (final item in SampleData.checklist)
                    CheckboxListTile(
                      key: ValueKey('check-${item.id}'),
                      value: inspection.checkedIds.contains(item.id),
                      onChanged: (_) =>
                          controller.toggleCheck(inspection, item.id),
                      title: Text(context.tr(item.arabic, item.english)),
                      subtitle: Text(
                        inspection.checkedIds.contains(item.id)
                            ? context.tr('تم التحقق', 'Verified')
                            : context.tr('قيد المراجعة', 'Pending review'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
            SectionTitle(context.tr('ملاحظات إضافية', 'Additional notes')),
            TextFormField(
              key: const ValueKey('inspection-notes'),
              initialValue: inspection.notes,
              minLines: 3,
              maxLines: 5,
              maxLength: 2000,
              decoration: InputDecoration(
                hintText: context.tr(
                  'اكتب ما لاحظته أثناء الزيارة…',
                  'Record your observations…',
                ),
              ),
              onChanged: (value) => inspection.notes = value,
            ),
            ResultFields(inspection: inspection),
          ],
        ),
      ),
    );
  }
}
