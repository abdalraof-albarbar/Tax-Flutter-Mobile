import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/record_count.dart';
import '../../core/theme.dart';
import '../../domain/business.dart';
import '../essentials/essentials_frame.dart';
import '../widgets/browse_empty.dart';
import '../widgets/browse_header.dart';
import '../widgets/browse_search.dart';
import 'business_card.dart';

class BusinessDirectoryScreen extends StatefulWidget {
  const BusinessDirectoryScreen({super.key});
  @override
  State<BusinessDirectoryScreen> createState() =>
      _BusinessDirectoryScreenState();
}

class _BusinessDirectoryScreenState extends State<BusinessDirectoryScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final businesses = Business.fromVisits(
      AppScope.of(context).visits,
      query: query,
    );
    return EssentialsFrame(
      title: context.tr('دليل الأنشطة', 'Business directory'),
      children: [
        BrowseHeader(
          title: context.tr(
            'نشاط واحد، كل زياراته',
            'One business, every visit',
          ),
          description: context.tr(
            'بيانات مجمعة من زيارات العينة، دون إضافة سجلات جديدة.',
            'Grouped from sample visits, without creating new records.',
          ),
          icon: Icons.storefront_outlined,
        ),
        BrowseSearch(
          id: 'business-search',
          value: query,
          label: context.tr('البحث في الأنشطة', 'Search businesses'),
          hint: context.tr(
            'الاسم أو المنطقة أو الرقم الضريبي',
            'Name, area or tax number',
          ),
          onChanged: (value) => setState(() => query = value),
        ),
        const SizedBox(height: Space.md),
        BrowseResultCount(
          label: RecordCount.businesses(context, businesses.length),
          onReset: query.isEmpty ? null : () => setState(() => query = ''),
        ),
        if (businesses.isEmpty)
          BrowseEmpty(
            title: context.tr('لا توجد أنشطة مطابقة', 'No matching businesses'),
            description: context.tr(
              'جرّب اسمًا أو منطقة أو رقمًا آخر.',
              'Try another name, area or tax number.',
            ),
            icon: Icons.search_off_rounded,
            action: context.tr('عرض كل الأنشطة', 'Show all businesses'),
            onAction: () => setState(() => query = ''),
          ),
        for (final business in businesses) BusinessCard(business: business),
      ],
    );
  }
}
