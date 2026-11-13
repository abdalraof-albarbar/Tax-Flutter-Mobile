import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../domain/inspection.dart';
import '../../domain/visit.dart';
import '../../core/theme.dart';
import '../../core/component_style.dart';

void showMessage(BuildContext context, String arabic, String english) {
  final compact =
      MediaQuery.sizeOf(context).width < ComponentTokens.compactFeedbackWidth ||
      MediaQuery.textScalerOf(context).scale(1) >
          ComponentTokens.compactFeedbackScale;
  final message = Text(
    context.tr(arabic, english),
    style: Theme.of(context).textTheme.bodyMedium,
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width:
          MediaQuery.sizeOf(context).width >= ComponentTokens.feedbackBreakpoint
          ? ComponentTokens.feedbackWidth
          : null,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Palette.white,
      showCloseIcon: !compact,
      closeIconColor: Palette.ink,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Space.radius),
        side: const BorderSide(color: Palette.border),
      ),
      content: compact
          ? message
          : Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Palette.deepTeal),
                const SizedBox(width: Space.md),
                Expanded(child: message),
              ],
            ),
    ),
  );
}

Future<bool> saveDraft(BuildContext context, Inspection inspection) async {
  final ok = await AppScope.of(context).save(inspection);
  if (context.mounted) {
    showMessage(
      context,
      ok
          ? 'تم حفظ المسودة على هذا الجهاز'
          : 'تعذر الحفظ. حاول مجددًا؛ المسودة ما زالت مفتوحة',
      ok
          ? 'Draft saved on this device'
          : 'Save failed. Retry; your draft is still open',
    );
  }
  return ok;
}

Future<void> openDirections(BuildContext context, Visit visit) async {
  try {
    final ok = await AppScope.of(context).directions.open(visit);
    if (!ok && context.mounted) {
      showMessage(context, 'تعذر فتح الخرائط', 'Could not open Maps');
    }
  } catch (_) {
    if (context.mounted) {
      showMessage(context, 'تعذر فتح الخرائط', 'Could not open Maps');
    }
  }
}
