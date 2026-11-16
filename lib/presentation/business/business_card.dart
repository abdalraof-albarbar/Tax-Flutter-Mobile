import 'package:flutter/material.dart';
import '../../core/app_page_route.dart';
import '../../core/browse_style.dart';
import '../../core/localization.dart';
import '../../core/record_count.dart';
import '../../core/theme.dart';
import '../../domain/business.dart';
import 'business_details_screen.dart';

class BusinessCard extends StatelessWidget {
  const BusinessCard({super.key, required this.business});
  final Business business;
  @override
  Widget build(BuildContext context) {
    final visit = business.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Material(
        color: Palette.white,
        shape: BrowseTokens.shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('business-${business.taxNumber}'),
          onTap: () => openAppPage<void>(
            context,
            BusinessDetailsScreen(business: business),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(visit.category, visit.englishCategory),
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: Palette.deepTeal),
                ),
                const SizedBox(height: Space.sm),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.tr(visit.name, visit.englishName),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Icon(
                      context.isArabic
                          ? Icons.chevron_left_rounded
                          : Icons.chevron_right_rounded,
                      color: Palette.deepTeal,
                    ),
                  ],
                ),
                const SizedBox(height: Space.sm),
                Text(context.tr(visit.area, visit.englishArea)),
                const SizedBox(height: Space.md),
                Wrap(
                  spacing: Space.md,
                  runSpacing: Space.xs,
                  children: [
                    Text(
                      visit.taxNumber,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${RecordCount.visits(context, business.visits.length)} ${context.tr('في العينة', 'in the sample')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
