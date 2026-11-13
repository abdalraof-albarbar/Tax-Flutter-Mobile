import 'package:flutter/material.dart';
import '../../app/profile_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/profile_options.dart';

class ProfilePreferences extends StatelessWidget {
  const ProfilePreferences({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = ProfileScope.of(context);
    final settings = controller.settings;
    final enabled =
        !controller.busy && !controller.loading && controller.error != 'load';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PreferenceCard(
          icon: Icons.language_rounded,
          title: context.tr('لغة التطبيق', 'App language'),
          subtitle: context.tr('اختر اللغة الأنسب لك', 'Make yourself at home'),
          child: Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final language in ProfileOptions.languages)
                ChoiceChip(
                  key: ValueKey('profile-language-${language.id}'),
                  label: Text(context.tr(language.arabic, language.english)),
                  selected: settings.language == language.id,
                  onSelected: enabled
                      ? (_) => controller.update(
                          settings.copyWith(language: language.id),
                        )
                      : null,
                ),
            ],
          ),
        ),
        const SizedBox(height: Space.lg),
        PreferenceCard(
          icon: Icons.text_fields_rounded,
          title: context.tr('حجم النص', 'Text size'),
          subtitle: context.tr(
            'قراءة أوضح أثناء العمل الميداني',
            'A comfortable read in the field',
          ),
          child: Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final size in ProfileOptions.textSizes)
                ChoiceChip(
                  key: ValueKey('profile-text-${size.scale}'),
                  label: Text(context.tr(size.arabic, size.english)),
                  selected: settings.textScale == size.scale,
                  onSelected: enabled
                      ? (_) => controller.update(
                          settings.copyWith(textScale: size.scale),
                        )
                      : null,
                ),
            ],
          ),
        ),
        const SizedBox(height: Space.lg),
        PreferenceCard(
          icon: Icons.auto_awesome_outlined,
          title: context.tr('تجربة أكثر هدوءًا', 'A calmer experience'),
          subtitle: context.tr(
            'تحكم في الحركة بين الصفحات',
            'Control motion between screens',
          ),
          child: SwitchListTile.adaptive(
            key: const ValueKey('profile-reduce-motion'),
            contentPadding: EdgeInsets.zero,
            title: Text(context.tr('تقليل الحركة', 'Reduce motion')),
            subtitle: Text(
              context.tr(
                'يُحترم إعداد الجهاز أيضًا',
                'Your device preference is also respected',
              ),
            ),
            value: settings.reduceMotion,
            onChanged: enabled
                ? (value) =>
                      controller.update(settings.copyWith(reduceMotion: value))
                : null,
          ),
        ),
      ],
    );
  }
}

class PreferenceCard extends StatelessWidget {
  const PreferenceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final IconData icon;
  final String title, subtitle;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(Space.lg),
    decoration: BoxDecoration(
      color: Palette.white,
      borderRadius: BorderRadius.circular(Space.radius),
      border: Border.all(color: Palette.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(Space.md),
              decoration: BoxDecoration(
                color: Palette.mint,
                borderRadius: BorderRadius.circular(Space.controlRadius),
              ),
              child: Icon(icon, color: Palette.teal),
            ),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.md),
        child,
      ],
    ),
  );
}
