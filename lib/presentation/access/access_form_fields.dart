import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/access.dart';
import 'access_field.dart';

class AccessFormFields extends StatelessWidget {
  const AccessFormFields({
    super.key,
    required this.intent,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmation,
    required this.enabled,
    required this.onSubmit,
  });
  final AccessIntent intent;
  final TextEditingController name, email, password, confirmation;
  final bool enabled;
  final VoidCallback onSubmit;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (intent == AccessIntent.signup)
        AccessField(
          fieldKey: 'access-name',
          label: context.tr('الاسم الكامل', 'Full name'),
          controller: name,
          enabled: enabled,
          validator: (value) => AccessValidation.name(value ?? '')
              ? null
              : context.tr(
                  'اكتب اسمًا من حرفين إلى 80 حرفًا',
                  'Enter a name of 2–80 characters',
                ),
        ),
      AccessField(
        fieldKey: 'access-email',
        label: context.tr('البريد الإلكتروني', 'Email address'),
        controller: email,
        email: true,
        enabled: enabled,
        onSubmitted: intent == AccessIntent.recovery ? onSubmit : null,
        validator: (value) => AccessValidation.email(value ?? '')
            ? null
            : context.tr(
                'اكتب بريدًا إلكترونيًا صالحًا',
                'Enter a valid email address',
              ),
      ),
      if (intent != AccessIntent.recovery) ...[
        AccessField(
          fieldKey: 'access-password',
          label: context.tr('كلمة المرور', 'Password'),
          controller: password,
          password: true,
          enabled: enabled,
          hint: context.tr('8 أحرف على الأقل', 'At least 8 characters'),
          onSubmitted: intent == AccessIntent.login ? onSubmit : null,
          validator: (value) => AccessValidation.password(value ?? '')
              ? null
              : context.tr('استخدم من 8 إلى 128 حرفًا', 'Use 8–128 characters'),
        ),
        if (intent == AccessIntent.signup)
          AccessField(
            fieldKey: 'access-confirmation',
            label: context.tr('تأكيد كلمة المرور', 'Confirm password'),
            controller: confirmation,
            password: true,
            enabled: enabled,
            onSubmitted: onSubmit,
            validator: (value) =>
                value == password.text && (value?.isNotEmpty ?? false)
                ? null
                : context.tr(
                    'كلمتا المرور غير متطابقتين',
                    'Passwords do not match',
                  ),
          ),
      ],
      Text(
        context.tr(
          'استخدم بيانات وهمية فقط في هذه المعاينة.',
          'Use made-up details only in this preview.',
        ),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      const SizedBox(height: Space.md),
    ],
  );
}
