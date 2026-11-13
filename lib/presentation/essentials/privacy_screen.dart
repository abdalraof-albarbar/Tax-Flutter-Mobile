import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/essential_samples.dart';
import 'essentials_frame.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) => EssentialsFrame(
    title: context.tr('الخصوصية وحدود التجربة', 'Privacy and demo limits'),
    children: [
      const Icon(
        Icons.info_outline_rounded,
        size: Space.touch,
        color: Palette.deepTeal,
      ),
      const SizedBox(height: Space.lg),
      Text(
        context.tr('اعرف أين تبقى بياناتك', 'Know where your data stays'),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: Space.sm),
      Text(
        context.tr(
          'هذا شرح للنسخة التجريبية الحالية، وليس شروط خدمة لحساب حقيقي.',
          'This explains the current demo, not terms for a real account.',
        ),
      ),
      const SizedBox(height: Space.xl),
      for (final article in EssentialSamples.privacy) ...[
        Text(
          article.question.text(context.isArabic),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: Space.sm),
        Text(article.answer.text(context.isArabic)),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: Space.lg),
          child: Divider(),
        ),
      ],
      Text(
        context.tr('عن الصور التوضيحية', 'About the illustrations'),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: Space.sm),
      Text(
        context.tr(
          'صور الترحيب والوصول مولدة بالذكاء الاصطناعي خصيصًا للتصميم. لا تمثل زيارات أو مستندات فعلية.',
          'The welcome and access illustrations were AI-generated for this design. They do not represent real visits or documents.',
        ),
      ),
    ],
  );
}
