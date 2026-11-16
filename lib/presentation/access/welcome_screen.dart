import 'package:flutter/material.dart';
import '../../core/app_page_route.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/access.dart';
import '../essentials/help_screen.dart';
import 'access_form_screen.dart';
import 'access_scaffold.dart';
import 'access_widgets.dart';
import 'onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => AccessScaffold(
    welcome: true,
    title: context.tr(
      'كل زيارة، خطوة أوضح',
      'Every visit. A clearer next step.',
    ),
    description: context.tr(
      'رتّب زياراتك، وثّق ملاحظاتك وراجع محاضرك مع تفتيش.',
      'Plan your visits, document observations and review reports with Tafteesh.',
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr('جاهز ليومك الميداني؟', 'Ready for your field day?'),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: Space.lg),
        AccessButton(
          key: const ValueKey('welcome-login'),
          label: context.tr('تسجيل الدخول', 'Sign in'),
          onPressed: () => openAppPage<void>(
            context,
            const AccessFormScreen(intent: AccessIntent.login),
          ),
        ),
        const SizedBox(height: Space.md),
        AccessButton(
          key: const ValueKey('welcome-signup'),
          outlined: true,
          label: context.tr('إنشاء حساب', 'Create account'),
          onPressed: () => openAppPage<void>(
            context,
            const AccessFormScreen(intent: AccessIntent.signup),
          ),
        ),
        const SizedBox(height: Space.md),
        TextButton(
          key: const ValueKey('welcome-demo'),
          onPressed: () => enterDemo(context),
          child: Text(
            context.tr('استكشف النسخة التجريبية', 'Explore the demo'),
          ),
        ),
        const SizedBox(height: Space.md),
        const DemoAccessNotice(),
        const SizedBox(height: Space.md),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            TextButton(
              key: const ValueKey('welcome-guide'),
              onPressed: () =>
                  openAppPage<void>(context, const OnboardingScreen()),
              child: Text(context.tr('كيف يعمل تفتيش؟', 'How does it work?')),
            ),
            TextButton(
              key: const ValueKey('welcome-help'),
              onPressed: () => openAppPage<void>(context, const HelpScreen()),
              child: Text(context.tr('تحتاج مساعدة؟', 'Need help?')),
            ),
          ],
        ),
      ],
    ),
  );
}
