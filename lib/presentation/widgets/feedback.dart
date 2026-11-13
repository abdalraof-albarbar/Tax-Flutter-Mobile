import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../domain/inspection.dart';
import '../../domain/visit.dart';

void showMessage(BuildContext context, String arabic, String english) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(context.tr(arabic, english))));
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
