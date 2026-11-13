import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/inspection.dart';
import '../widgets/surface.dart';

class ReportTimeline extends StatelessWidget {
  const ReportTimeline({super.key, required this.inspection});
  final Inspection inspection;
  @override
  Widget build(BuildContext context) => Surface(
    child: Column(
      children: [
        ListTile(
          leading: const Icon(Icons.check_circle, color: Palette.green),
          title: Text(context.tr('تم الحفظ محليًا', 'Saved locally')),
          subtitle: Text(
            inspection.submittedAt == null
                ? '—'
                : MaterialLocalizations.of(
                    context,
                  ).formatFullDate(inspection.submittedAt!),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Palette.mint,
            borderRadius: BorderRadius.circular(Space.controlRadius),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.radio_button_checked,
              color: Palette.teal,
            ),
            title: Text(context.tr('قيد المراجعة', 'Under review')),
            subtitle: Text(
              context.tr(
                'حالة تجريبية؛ لا يوجد اتصال بجهة مراجعة',
                'Demo status; no reviewing authority is connected',
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.radio_button_off, color: Palette.muted),
          title: Text(context.tr('الاعتماد النهائي', 'Final approval')),
          subtitle: Text(
            context.tr(
              'غير متاح في النموذج التجريبي',
              'Unavailable in this demo',
            ),
          ),
        ),
      ],
    ),
  );
}
