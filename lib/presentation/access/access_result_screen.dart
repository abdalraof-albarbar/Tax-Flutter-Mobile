import 'package:flutter/material.dart';
import '../../core/access_style.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/access.dart';
import 'access_scaffold.dart';
import 'access_widgets.dart';

class AccessResultScreen extends StatelessWidget {
  const AccessResultScreen({super.key, required this.intent});
  final AccessIntent intent;
  @override
  Widget build(BuildContext context) => AccessScaffold(
    image: AccessTokens.folioImage,
    title: context.tr('النموذج جاهز للمعاينة', 'Your form preview is ready'),
    description: intent == AccessIntent.recovery
        ? context.tr(
            'راجعت تنسيق البريد. لم يتم إرسال رابط استعادة.',
            'The email format was checked. No reset link was sent.',
          )
        : context.tr(
            'اكتملت مراجعة الحقول. يمكنك الآن استكشاف تجربة المفتش.',
            'The fields passed validation. You can now explore the inspector demo.',
          ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.task_alt_rounded,
          size: Space.touch,
          color: Palette.deepTeal,
        ),
        const SizedBox(height: Space.lg),
        Text(
          context.tr('تجربتك تبدأ من هنا', 'Explore from here'),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: Space.md),
        Text(
          intent == AccessIntent.signup
              ? context.tr(
                  'لم يُنشأ حساب حقيقي. بيانات النموذج لا تُحفظ، وكلمة المرور لا تُخزّن.',
                  'No real account was created. Form details and passwords are not stored.',
                )
              : intent == AccessIntent.login
              ? context.tr(
                  'هذا ليس دخولًا لحساب حقيقي. ستفتح مساحة ببيانات نموذجية ثابتة.',
                  'This is not a real account sign-in. You will open a workspace with fixed sample data.',
                )
              : context.tr(
                  'خدمة البريد غير مربوطة في هذه النسخة. يمكنك العودة للدخول أو فتح التجربة.',
                  'Email delivery is not connected in this version. Return to sign in or explore the demo.',
                ),
        ),
        const SizedBox(height: Space.xl),
        AccessButton(
          key: const ValueKey('access-result-demo'),
          label: context.tr('فتح التجربة', 'Open demo'),
          onPressed: () => enterDemo(context),
        ),
      ],
    ),
  );
}
