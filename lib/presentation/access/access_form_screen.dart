import 'package:flutter/material.dart';
import '../../app/access_scope.dart';
import '../../core/access_style.dart';
import '../../core/app_page_route.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/access.dart';
import '../essentials/privacy_screen.dart';
import 'access_form_fields.dart';
import 'access_result_screen.dart';
import 'access_scaffold.dart';
import 'access_widgets.dart';

class AccessFormScreen extends StatefulWidget {
  const AccessFormScreen({super.key, required this.intent});
  final AccessIntent intent;
  @override
  State<AccessFormScreen> createState() => _AccessFormScreenState();
}

class _AccessFormScreenState extends State<AccessFormScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController();
  final password = TextEditingController(),
      confirmation = TextEditingController();
  bool consent = false, submitted = false, previewFailed = false;
  bool get signup => widget.intent == AccessIntent.signup;
  bool get recovery => widget.intent == AccessIntent.recovery;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmation.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final access = AccessScope.of(context);
    if (access.busy) return;
    setState(() {
      submitted = true;
      previewFailed = false;
    });
    if (!form.currentState!.validate() || (signup && !consent)) return;
    FocusScope.of(context).unfocus();
    final success = await access.submit(
      AccessRequest(
        intent: widget.intent,
        name: name.text.trim(),
        email: email.text.trim(),
        password: password.text,
      ),
    );
    if (!mounted) return;
    if (!success) {
      setState(() => previewFailed = access.failed);
      return;
    }
    if (ModalRoute.of(context)?.isCurrent != true) return;
    name.clear();
    email.clear();
    password.clear();
    confirmation.clear();
    Navigator.pushReplacement(
      context,
      AppPageRoute<void>(
        child: AccessResultScreen(intent: widget.intent),
        reduceMotion: MediaQuery.disableAnimationsOf(context),
      ),
    );
  }

  void replaceWith(AccessIntent intent) => Navigator.pushReplacement(
    context,
    AppPageRoute<void>(
      child: AccessFormScreen(intent: intent),
      reduceMotion: MediaQuery.disableAnimationsOf(context),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final access = AccessScope.of(context);
    final title = recovery
        ? context.tr('نرجعك لمسارك', 'Find your way back')
        : signup
        ? context.tr('ابدأ مع تفتيش', 'Start with Tafteesh')
        : context.tr('أهلًا بعودتك', 'Welcome back');
    final action = recovery
        ? context.tr('معاينة طلب الاستعادة', 'Preview reset request')
        : signup
        ? context.tr('إنشاء حساب', 'Create account')
        : context.tr('تسجيل الدخول', 'Sign in');
    return AccessScaffold(
      title: title,
      image: recovery || signup
          ? AccessTokens.folioImage
          : AccessTokens.welcomeImage,
      description: recovery
          ? context.tr(
              'أدخل بريدك لمعاينة خطوات استعادة الوصول.',
              'Enter your email to preview account recovery.',
            )
          : signup
          ? context.tr(
              'جهّز ملفك وابدأ يومك الميداني بخطوات واضحة.',
              'Set up your profile and start your field day with clear steps.',
            )
          : context.tr(
              'جدولك، زياراتك ومحاضرك في مساحة واحدة.',
              'Your schedule, visits and reports in one workspace.',
            ),
      child: Form(
        key: form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(action, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: Space.md),
            const DemoAccessNotice(),
            const SizedBox(height: Space.xl),
            AccessFormFields(
              intent: widget.intent,
              name: name,
              email: email,
              password: password,
              confirmation: confirmation,
              enabled: !access.busy,
              onSubmit: submit,
            ),
            if (!signup && !recovery)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  key: const ValueKey('access-forgot'),
                  onPressed: access.busy
                      ? null
                      : () => openAppPage<void>(
                          context,
                          const AccessFormScreen(intent: AccessIntent.recovery),
                        ),
                  child: Text(
                    context.tr('نسيت كلمة المرور؟', 'Forgot password?'),
                  ),
                ),
              ),
            if (signup) ...[
              CheckboxListTile(
                key: const ValueKey('access-consent'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: consent,
                onChanged: access.busy
                    ? null
                    : (value) => setState(() => consent = value ?? false),
                title: Text(
                  context.tr(
                    'أفهم أن هذه تجربة وأستخدم بيانات وهمية.',
                    'I understand this is a demo and use made-up details.',
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              if (submitted && !consent)
                Text(
                  context.tr(
                    'أكد فهم حدود التجربة للمتابعة.',
                    'Confirm the demo limits to continue.',
                  ),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
            if (previewFailed)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.md),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    context.tr(
                      'تعذرت معاينة النموذج. مدخلاتك باقية؛ حاول مجددًا.',
                      'Could not preview the form. Your entries are kept; try again.',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            AccessButton(
              key: const ValueKey('access-submit'),
              label: action,
              busy: access.busy,
              onPressed: submit,
            ),
            const SizedBox(height: Space.sm),
            if (!recovery)
              TextButton(
                key: const ValueKey('access-switch-form'),
                onPressed: access.busy
                    ? null
                    : () => replaceWith(
                        signup ? AccessIntent.login : AccessIntent.signup,
                      ),
                child: Text(
                  signup
                      ? context.tr(
                          'عندك حساب؟ تسجيل الدخول',
                          'Have an account? Sign in',
                        )
                      : context.tr(
                          'جديد هنا؟ إنشاء حساب',
                          'New here? Create account',
                        ),
                ),
              ),
            TextButton(
              key: const ValueKey('access-explore'),
              onPressed: access.busy ? null : () => enterDemo(context),
              child: Text(
                context.tr(
                  'استكشف دون إدخال بيانات',
                  'Explore without entering details',
                ),
              ),
            ),
            TextButton(
              key: const ValueKey('access-privacy'),
              onPressed: access.busy
                  ? null
                  : () {
                      if (access.busy) return;
                      openAppPage<void>(context, const PrivacyScreen());
                    },
              child: Text(
                context.tr('الخصوصية وحدود التجربة', 'Privacy and demo limits'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
