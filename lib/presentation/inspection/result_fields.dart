import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';
import '../../domain/inspection.dart';
import '../widgets/surface.dart';

class ResultFields extends StatelessWidget {
  const ResultFields({
    super.key,
    required this.inspection,
    this.showViolation = false,
  });
  final Inspection inspection;
  final bool showViolation;
  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(context.tr('نتيجة المعاينة', 'Inspection result')),
        Surface(
          padding: Space.xs,
          child: Column(
            children: [
              for (final hasFindings in [false, true])
                ListTile(
                  key: ValueKey('result-$hasFindings'),
                  selected: inspection.hasFindings == hasFindings,
                  onTap: () {
                    if (inspection.submitted) return;
                    inspection.hasFindings = hasFindings;
                    if (!hasFindings) inspection.violationId = null;
                    controller.changed();
                  },
                  leading: Icon(
                    inspection.hasFindings == hasFindings
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: inspection.hasFindings == hasFindings
                        ? Palette.teal
                        : Palette.muted,
                  ),
                  title: Text(
                    hasFindings
                        ? context.tr('توجد ملاحظات', 'Findings recorded')
                        : context.tr('لا توجد ملاحظات', 'No findings'),
                  ),
                ),
            ],
          ),
        ),
        if (showViolation && inspection.hasFindings == true) ...[
          const SizedBox(height: Space.lg),
          DropdownButtonFormField<String>(
            key: const ValueKey('violation'),
            initialValue: inspection.violationId,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: context.tr(
                'نوع الملاحظة التجريبية',
                'Sample finding type',
              ),
            ),
            items: [
              for (final item in SampleData.violations)
                DropdownMenuItem(
                  value: item.id,
                  child: Text(context.tr(item.arabic, item.english)),
                ),
            ],
            onChanged: inspection.submitted
                ? null
                : (value) {
                    inspection.violationId = value;
                    controller.changed();
                  },
          ),
        ],
      ],
    );
  }
}
