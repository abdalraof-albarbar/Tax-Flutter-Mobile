import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/visit.dart';
import '../widgets/surface.dart';

class BusinessFacts extends StatelessWidget {
  const BusinessFacts({super.key, required this.visit});
  final Visit visit;
  @override
  Widget build(BuildContext context) {
    final facts = [
      (
        Icons.description_outlined,
        context.tr('الرقم الضريبي', 'Tax number'),
        visit.taxNumber,
      ),
      (
        Icons.work_outline,
        context.tr('النوع', 'Type'),
        context.tr(visit.category, visit.englishCategory),
      ),
      (
        Icons.location_on_outlined,
        context.tr('المنطقة', 'Area'),
        context.tr(visit.area, visit.englishArea),
      ),
      (
        Icons.schedule,
        context.tr('المدة المتوقعة', 'Expected duration'),
        '${visit.durationMinutes} ${context.tr('دقيقة', 'minutes')}',
      ),
    ];
    return Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('بيانات النشاط', 'Business details'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: Space.lg),
          LayoutBuilder(
            builder: (context, box) => Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [
                for (final fact in facts)
                  SizedBox(
                    width: box.maxWidth < 320
                        ? box.maxWidth
                        : (box.maxWidth - Space.sm) / 2,
                    child: Surface(
                      color: Palette.background,
                      padding: Space.md,
                      child: Row(
                        children: [
                          Icon(fact.$1, color: Palette.deepTeal),
                          const SizedBox(width: Space.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fact.$2,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  fact.$3,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
