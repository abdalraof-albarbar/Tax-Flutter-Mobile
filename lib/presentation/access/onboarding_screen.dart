import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/essential_samples.dart';
import 'access_scaffold.dart';
import 'access_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final steps = EssentialSamples.guide;
    final step = steps[index];
    final last = index == steps.length - 1;
    return AccessScaffold(
      welcome: true,
      image: step.image,
      title: step.title.text(context.isArabic),
      description: step.description.text(context.isArabic),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            liveRegion: true,
            child: Text(
              context.tr(
                'الخطوة ${index + 1} من ${steps.length}',
                'Step ${index + 1} of ${steps.length}',
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: Space.lg),
          LinearProgressIndicator(
            value: (index + 1) / steps.length,
            color: Palette.deepTeal,
            backgroundColor: Palette.mint,
          ),
          const SizedBox(height: Space.xl),
          AccessButton(
            key: const ValueKey('guide-next'),
            label: last
                ? context.tr('ابدأ التجربة', 'Start exploring')
                : context.tr('التالي', 'Next'),
            onPressed: () =>
                last ? enterDemo(context) : setState(() => index++),
          ),
          if (index > 0)
            TextButton(
              key: const ValueKey('guide-previous'),
              onPressed: () => setState(() => index--),
              child: Text(context.tr('السابق', 'Previous')),
            ),
          const SizedBox(height: Space.md),
          const DemoAccessNotice(),
        ],
      ),
    );
  }
}
