import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/essential_samples.dart';
import 'essentials_frame.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});
  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final search = TextEditingController();
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = search.text.trim().toLowerCase();
    final articles = EssentialSamples.help
        .where(
          (article) =>
              '${article.question.text(context.isArabic)} ${article.answer.text(context.isArabic)}'
                  .toLowerCase()
                  .contains(query),
        )
        .toList();
    return EssentialsFrame(
      title: context.tr('المساعدة', 'Help'),
      children: [
        Text(
          context.tr('شن تبي تعرف؟', 'How can we help?'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Space.sm),
        Text(
          context.tr(
            'إجابات واضحة عن استخدام النسخة التجريبية.',
            'Clear answers about using the demo.',
          ),
        ),
        const SizedBox(height: Space.xl),
        TextField(
          key: const ValueKey('help-search'),
          controller: search,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: context.tr('ابحث في المساعدة', 'Search help'),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: query.isEmpty
                ? null
                : IconButton(
                    tooltip: context.tr('مسح البحث', 'Clear search'),
                    onPressed: () => setState(search.clear),
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
        const SizedBox(height: Space.xl),
        if (articles.isEmpty) ...[
          const Icon(
            Icons.search_off_rounded,
            size: Space.touch,
            color: Palette.muted,
          ),
          Text(
            context.tr('ما لقيناش إجابة مطابقة', 'No matching answers'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            context.tr(
              'جرّب كلمات مثل مسودة، صور أو حساب.',
              'Try words like draft, photos or account.',
            ),
          ),
          TextButton(
            key: const ValueKey('help-reset'),
            onPressed: () => setState(search.clear),
            child: Text(context.tr('عرض كل الأسئلة', 'Show all questions')),
          ),
        ],
        for (final article in articles)
          Card(
            elevation: 0,
            color: Palette.white,
            margin: const EdgeInsets.only(bottom: Space.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Space.radius),
              side: const BorderSide(color: Palette.border),
            ),
            child: ExpansionTile(
              expansionAnimationStyle: AnimationStyle(
                duration: MotionTokens.duration(context),
                reverseDuration: MotionTokens.duration(context),
              ),
              key: PageStorageKey(article.id),
              title: Text(
                article.question.text(context.isArabic),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              childrenPadding: const EdgeInsets.all(Space.lg),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(article.answer.text(context.isArabic))],
            ),
          ),
      ],
    );
  }
}
