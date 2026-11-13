import 'package:flutter/material.dart';
import '../../app/access_scope.dart';
import '../../core/access_style.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';

class AccessButton extends StatelessWidget {
  const AccessButton({
    super.key,
    required this.label,
    this.onPressed,
    this.outlined = false,
    this.busy = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool outlined, busy;
  @override
  Widget build(BuildContext context) {
    final child = Text(
      busy ? context.tr('جارٍ التحقق…', 'Checking…') : label,
      textAlign: TextAlign.center,
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AccessTokens.buttonHeight),
      child: outlined
          ? OutlinedButton(onPressed: onPressed, child: child)
          : FilledButton(onPressed: busy ? null : onPressed, child: child),
    );
  }
}

class DemoAccessNotice extends StatelessWidget {
  const DemoAccessNotice({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(Space.md),
    decoration: BoxDecoration(
      color: Palette.mint,
      borderRadius: BorderRadius.circular(Space.controlRadius),
    ),
    child: Text(
      context.tr(
        'معاينة تفاعلية فقط. استخدم بيانات وهمية؛ لا يتم إنشاء حسابات أو إرسال بريد.',
        'Interactive preview only. Use made-up details; no accounts are created or emails sent.',
      ),
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Palette.deepTeal),
    ),
  );
}

void enterDemo(BuildContext context) {
  final access = AccessScope.of(context);
  Navigator.popUntil(context, (route) => route.isFirst);
  access.startDemo();
}
