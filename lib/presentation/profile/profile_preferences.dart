import 'package:flutter/material.dart';
import '../../app/profile_scope.dart';
import '../../core/localization.dart';
import '../../core/profile_style.dart';
import '../../core/theme.dart';
import '../../data/profile_options.dart';
import '../../data/sample_data.dart';
import 'profile_segmented_control.dart';

class ProfilePreferences extends StatelessWidget {
  const ProfilePreferences({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = ProfileScope.of(context);
    return Container(
      decoration: ProfileTokens.panel,
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= ProfileTokens.wideLayout) {
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _LanguageSection()),
                    SizedBox(width: Space.xl),
                    Expanded(child: _ReadingSection()),
                  ],
                );
              }
              return const Column(
                children: [
                  _LanguageSection(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Space.lg),
                    child: Divider(),
                  ),
                  _ReadingSection(),
                ],
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Space.md),
            child: Divider(),
          ),
          SwitchListTile.adaptive(
            key: const ValueKey('profile-reduce-motion'),
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(
              Icons.slow_motion_video_rounded,
              color: Palette.deepTeal,
            ),
            title: Text(
              context.tr('تقليل الحركة', 'Reduce motion'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              context.tr(
                'انتقالات أقل، مع احترام إعداد الجهاز',
                'Fewer transitions, respecting your device setting',
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: controller.settings.reduceMotion,
            onChanged: controller.canEdit
                ? (value) => controller.update(
                    controller.settings.copyWith(reduceMotion: value),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection();
  @override
  Widget build(BuildContext context) {
    final controller = ProfileScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PreferenceHeading(
          icon: Icons.language_rounded,
          title: context.tr('لغة التطبيق', 'App language'),
          description: context.tr(
            'اختر لغة العرض',
            'Choose your display language',
          ),
        ),
        const SizedBox(height: Space.lg),
        ProfileSegmentedControl<String>(
          selected: controller.settings.language,
          keyPrefix: 'profile-language',
          options: [
            for (final option in ProfileOptions.languages)
              ProfileSegment(
                value: option.id,
                label: context.tr(option.arabic, option.english),
              ),
          ],
          onSelected: controller.canEdit
              ? (value) => controller.update(
                  controller.settings.copyWith(language: value),
                )
              : null,
        ),
      ],
    );
  }
}

class _ReadingSection extends StatelessWidget {
  const _ReadingSection();
  @override
  Widget build(BuildContext context) {
    final controller = ProfileScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PreferenceHeading(
          icon: Icons.text_fields_rounded,
          title: context.tr('حجم النص', 'Text size'),
          description: context.tr(
            'اختر مقاسًا مريحًا للقراءة',
            'Find a comfortable reading size',
          ),
        ),
        const SizedBox(height: Space.lg),
        ProfileSegmentedControl<double>(
          selected: controller.settings.textScale,
          keyPrefix: 'profile-text',
          options: [
            for (final option in ProfileOptions.textSizes)
              ProfileSegment(
                value: option.scale,
                label: context.tr(option.arabic, option.english),
              ),
          ],
          onSelected: controller.canEdit
              ? (value) => controller.update(
                  controller.settings.copyWith(textScale: value),
                )
              : null,
        ),
        const SizedBox(height: Space.md),
        Container(
          padding: const EdgeInsets.all(Space.md),
          decoration: BoxDecoration(
            color: Palette.background,
            borderRadius: BorderRadius.circular(Space.controlRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('معاينة النص', 'Text preview'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                SampleData.inspector[context.isArabic ? 0 : 1],
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreferenceHeading extends StatelessWidget {
  const _PreferenceHeading({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title, description;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: Palette.deepTeal),
      const SizedBox(width: Space.md),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    ],
  );
}
