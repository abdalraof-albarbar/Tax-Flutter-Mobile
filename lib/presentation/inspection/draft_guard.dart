import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../domain/inspection.dart';
import '../widgets/feedback.dart';

/// A failed save keeps the route open instead of silently losing the draft.
class DraftGuard extends StatefulWidget {
  const DraftGuard({super.key, required this.inspection, required this.child});
  final Inspection inspection;
  final Widget child;
  @override
  State<DraftGuard> createState() => _DraftGuardState();
}

class _DraftGuardState extends State<DraftGuard> {
  bool allowPop = false, saving = false;
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: allowPop || widget.inspection.submitted,
    onPopInvokedWithResult: (didPop, result) async {
      if (didPop || saving) return;
      saving = true;
      final ok = await AppScope.of(context).save(widget.inspection);
      saving = false;
      if (!context.mounted) return;
      if (!ok) {
        showMessage(
          context,
          'تعذر حفظ المسودة. حاول مجددًا قبل الرجوع.',
          'Draft could not be saved. Retry before leaving.',
        );
        return;
      }
      setState(() => allowPop = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.pop(context, result);
      });
    },
    child: widget.child,
  );
}
