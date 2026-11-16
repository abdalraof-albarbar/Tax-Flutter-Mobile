import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/business.dart';
import '../essentials/essentials_frame.dart';
import '../reports/report_card.dart';
import '../visits/visit_schedule_card.dart';
import '../widgets/browse_empty.dart';
import '../widgets/browse_header.dart';
import '../widgets/surface.dart';

class BusinessDetailsScreen extends StatelessWidget {
  const BusinessDetailsScreen({super.key, required this.business});
  final Business business;
  @override
  Widget build(BuildContext context) {
    final visit = business.primary;
    final reports = AppScope.of(context).reports
        .where(
          (report) =>
              business.visits.any((visit) => visit.id == report.visitId),
        )
        .toList();
    return EssentialsFrame(
      title: context.tr('ملف النشاط', 'Business profile'),
      children: [
        BrowseHeader(
          title: context.tr(visit.name, visit.englishName),
          description: context.tr(visit.category, visit.englishCategory),
          icon: Icons.apartment_outlined,
        ),
        Surface(
          color: Palette.mint,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('الرقم الضريبي', 'Tax number'),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Semantics(
                container: true,
                label: context.tr(
                  'الرقم الضريبي ${visit.taxNumber}',
                  'Tax number ${visit.taxNumber}',
                ),
                child: ExcludeSemantics(
                  child: SelectableText(
                    visit.taxNumber,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              const SizedBox(height: Space.md),
              Text(
                context.tr('المنطقة', 'Area'),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(context.tr(visit.area, visit.englishArea)),
            ],
          ),
        ),
        SectionTitle(context.tr('زيارات النشاط', 'Business visits')),
        for (final visit in business.visits)
          VisitScheduleCard(visit: visit, showDate: true),
        SectionTitle(context.tr('محاضر النشاط', 'Reports for this business')),
        if (reports.isEmpty)
          BrowseEmpty(
            title: context.tr(
              'لا توجد محاضر لهذا النشاط',
              'No reports for this business',
            ),
            description: context.tr(
              'الزيارة المكتملة في العينة لا تنشئ محضرًا وهميًا. افتح زيارة للبدء.',
              'A completed sample visit does not create a fictional report. Open a visit to begin.',
            ),
            icon: Icons.description_outlined,
          ),
        for (final report in reports) ReportCard(inspection: report),
        const SizedBox(height: Space.lg),
        Notice(
          context.tr(
            'بيانات تجريبية مشتقة من قوائم الزيارات فقط.',
            'Sample information derived only from visit lists.',
          ),
        ),
      ],
    );
  }
}
