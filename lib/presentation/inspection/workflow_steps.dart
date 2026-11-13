import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';

class WorkflowSteps extends StatelessWidget {
  const WorkflowSteps({super.key, required this.current});
  final int current;
  @override
  Widget build(BuildContext context) {
    final labels = [
      context.tr('التحقق', 'Checklist'),
      context.tr('المرفقات', 'Attachments'),
      context.tr('المحضر', 'Report'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: Space.lg),
                  child: Divider(
                    color: i <= current ? Palette.teal : Palette.border,
                    thickness: 2,
                  ),
                ),
              ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Semantics(
                    label: '${i + 1} ${labels[i]}',
                    selected: i == current,
                    child: CircleAvatar(
                      radius: Space.lg,
                      backgroundColor: i <= current
                          ? Palette.teal
                          : Palette.border,
                      foregroundColor: i <= current
                          ? Palette.white
                          : Palette.muted,
                      child: i < current
                          ? const Icon(Icons.check, size: Space.xl)
                          : Text('${i + 1}'),
                    ),
                  ),
                  const SizedBox(height: Space.sm),
                  Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: i == current ? Palette.deepTeal : Palette.muted,
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
