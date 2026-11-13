import 'package:flutter/material.dart';
import '../../app/profile_scope.dart';
import '../../core/localization.dart';

class ProfileRecoveryActions extends StatelessWidget {
  const ProfileRecoveryActions({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = ProfileScope.of(context);
    return TextButton.icon(
      key: const ValueKey('reset-profile'),
      icon: const Icon(Icons.settings_backup_restore_rounded),
      label: Text(
        context.tr('استعادة الإعدادات الافتراضية', 'Restore default settings'),
      ),
      onPressed: controller.canReset
          ? () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    context.tr(
                      'استعادة إعدادات الملف؟',
                      'Reset profile settings?',
                    ),
                  ),
                  content: Text(
                    context.tr(
                      'سيتم استبدال الصورة وتفضيلات اللغة والنص والحركة بالإعدادات الافتراضية. '
                          'تبقى مسودات التفتيش محفوظة.',
                      'This replaces the profile photo, language, text size and motion preferences '
                          'with defaults. Inspection drafts are preserved.',
                    ),
                  ),
                  actions: [
                    TextButton(
                      key: const ValueKey('cancel-profile-reset'),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(context.tr('إلغاء', 'Cancel')),
                    ),
                    FilledButton(
                      key: const ValueKey('confirm-profile-reset'),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        context.tr('استعادة الإعدادات', 'Reset settings'),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed == true) await controller.resetCorruptSettings();
            }
          : null,
    );
  }
}
