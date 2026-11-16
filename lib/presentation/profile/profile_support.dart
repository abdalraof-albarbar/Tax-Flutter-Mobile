import 'package:flutter/material.dart';
import '../../app/access_scope.dart';
import '../../core/app_page_route.dart';
import '../../core/localization.dart';
import '../../core/profile_style.dart';
import '../../core/theme.dart';
import '../essentials/help_screen.dart';
import '../essentials/privacy_screen.dart';

class ProfileSupport extends StatelessWidget {
  const ProfileSupport({super.key});
  Future<void> endDemo(BuildContext context) async {
    final access = AccessScope.maybeOf(context);
    if (access == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      animationStyle: ProfileTokens.animationStyle(context),
      builder: (context) => AlertDialog(
        title: Text(context.tr('إنهاء التجربة؟', 'End this demo?')),
        content: Text(
          context.tr(
            'سترجع للترحيب. تبقى مسوداتك وصورتك وتفضيلاتك على الجهاز.',
            'Return to Welcome. Your drafts, photo and preferences stay on this device.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.tr('البقاء', 'Stay')),
          ),
          FilledButton(
            key: const ValueKey('confirm-end-demo'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.tr('إنهاء التجربة', 'End demo')),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
      access.endDemo();
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: ProfileTokens.panel,
    child: Column(
      children: [
        ListTile(
          key: const ValueKey('profile-help'),
          leading: const Icon(
            Icons.help_outline_rounded,
            color: Palette.deepTeal,
          ),
          title: Text(
            context.tr(
              'المساعدة والأسئلة الشائعة',
              'Help and common questions',
            ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => openAppPage<void>(context, const HelpScreen()),
        ),
        const Divider(height: 1),
        ListTile(
          key: const ValueKey('profile-privacy'),
          leading: const Icon(
            Icons.info_outline_rounded,
            color: Palette.deepTeal,
          ),
          title: Text(
            context.tr('الخصوصية وحدود التجربة', 'Privacy and demo limits'),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => openAppPage<void>(context, const PrivacyScreen()),
        ),
        if (AccessScope.maybeOf(context)?.exploring ?? false) ...[
          const Divider(height: 1),
          ListTile(
            key: const ValueKey('profile-end-demo'),
            leading: const Icon(Icons.logout_rounded, color: Palette.deepTeal),
            title: Text(context.tr('إنهاء التجربة', 'End demo')),
            onTap: () => endDemo(context),
          ),
        ],
      ],
    ),
  );
}
