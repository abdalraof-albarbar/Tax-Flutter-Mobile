import 'package:flutter/material.dart';
import '../../core/app_information.dart';
import '../../core/localization.dart';
import '../../core/profile_style.dart';
import '../../core/theme.dart';

class ProfilePrivacy extends StatelessWidget {
  const ProfilePrivacy({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        padding: const EdgeInsets.all(Space.lg),
        decoration: BoxDecoration(
          color: Palette.mint,
          borderRadius: BorderRadius.circular(Space.controlRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.phonelink_lock_outlined, color: Palette.deepTeal),
            const SizedBox(width: Space.md),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: ProfileTokens.copyWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('على هذا الجهاز فقط', 'Only on this device'),
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Palette.deepTeal),
                    ),
                    const SizedBox(height: Space.xs),
                    Text(
                      context.tr(
                        'الصورة والتفضيلات محفوظة محليًا دون تشفير. استخدم بيانات تجريبية.',
                        'Your photo and preferences stay locally, unencrypted. Use sample data.',
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: Space.xl),
      Text(
        context.tr('تفتيش • الإصدار ', 'Inspection • Version ') +
            AppInformation.version,
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
