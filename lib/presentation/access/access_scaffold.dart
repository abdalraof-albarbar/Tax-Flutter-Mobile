import 'package:flutter/material.dart';
import '../../app/profile_scope.dart';
import '../../core/access_style.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../widgets/feedback.dart';

class AccessScaffold extends StatelessWidget {
  const AccessScaffold({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    this.image = AccessTokens.welcomeImage,
    this.welcome = false,
  });
  final String title, description, image;
  final Widget child;
  final bool welcome;
  @override
  Widget build(BuildContext context) => Theme(
    data: AccessTokens.theme(Theme.of(context)),
    child: Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide =
                constraints.maxWidth >= AccessTokens.wide &&
                MediaQuery.textScalerOf(context).scale(1) <
                    AccessTokens.wideTextScaleLimit;
            final heading = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AccessTokens.panelRadius),
                  child: ExcludeSemantics(
                    child: Image.asset(
                      image,
                      height: wide
                          ? AccessTokens.wideImageHeight
                          : welcome
                          ? AccessTokens.welcomeImageHeight
                          : AccessTokens.imageHeight,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: Space.xl),
                Text(title, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: Space.sm),
                Text(description, style: Theme.of(context).textTheme.bodyLarge),
              ],
            );
            final form = Container(
              decoration: AccessTokens.panel,
              padding: const EdgeInsets.all(Space.xl),
              child: child,
            );
            return SingleChildScrollView(
              key: const ValueKey('access-scroll'),
              padding: const EdgeInsets.all(Space.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AccessTokens.content,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _AccessTopBar(),
                      const SizedBox(height: Space.xl),
                      if (wide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: heading),
                            const SizedBox(width: Space.xxl),
                            SizedBox(
                              width: AccessTokens.formWidth,
                              child: form,
                            ),
                          ],
                        )
                      else
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: AccessTokens.formWidth,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                heading,
                                const SizedBox(height: Space.xl),
                                form,
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: Space.xl),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _AccessTopBar extends StatelessWidget {
  const _AccessTopBar();
  @override
  Widget build(BuildContext context) {
    final profile = ProfileScope.of(context);
    return Row(
      children: [
        if (Navigator.canPop(context))
          IconButton(
            key: const ValueKey('access-back'),
            tooltip: context.tr('رجوع', 'Back'),
            onPressed: () => Navigator.maybePop(context),
            icon: const BackButtonIcon(),
          ),
        Expanded(
          child: Text(
            context.tr('تفتيش', 'Tafteesh'),
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: Palette.deepTeal),
          ),
        ),
        TextButton(
          key: const ValueKey('access-language'),
          onPressed: !profile.canEdit
              ? null
              : () async {
                  if (!profile.canEdit) return;
                  final saved = await profile.update(
                    profile.settings.copyWith(
                      language: context.isArabic ? 'en' : 'ar',
                    ),
                  );
                  if (!saved && profile.error == 'save' && context.mounted) {
                    showMessage(
                      context,
                      'تعذر حفظ اللغة. حاول مجددًا.',
                      'Could not save language. Please retry.',
                    );
                  }
                },
          child: Text(context.tr('EN', 'عربي')),
        ),
      ],
    );
  }
}
