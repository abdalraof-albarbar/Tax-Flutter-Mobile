import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../application/visit_browser_controller.dart';
import '../../core/app_page_route.dart';
import '../../core/localization.dart';
import '../../core/record_count.dart';
import '../../core/theme.dart';
import '../../data/browse_options.dart';
import '../../data/sample_data.dart';
import '../../domain/browse_choice.dart';
import '../business/business_directory_screen.dart';
import '../widgets/browse_choices.dart';
import '../widgets/browse_empty.dart';
import '../widgets/browse_header.dart';
import '../widgets/browse_search.dart';
import '../widgets/screen_frame.dart';
import 'route_sheet.dart';
import 'visit_filters.dart';
import 'visit_schedule_card.dart';
import 'visit_filter_sheet.dart';

class VisitsScreen extends StatefulWidget {
  const VisitsScreen({super.key, this.browser});
  final VisitBrowserController? browser;
  @override
  State<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  late final browser =
      widget.browser ?? VisitBrowserController(scheduleDate: SampleData.date);
  @override
  void dispose() {
    if (widget.browser == null) browser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: browser,
    builder: (context, _) {
      final visits = browser.results(AppScope.of(context));
      return PageBody(
        storageKey: 'visits',
        children: [
          BrowseHeader(
            title: context.tr('زياراتك، بوضوح', 'Your visit schedule'),
            description: context.tr(
              'ابحث، رتّب وواصل زيارتك من مكان واحد.',
              'Find, organise and continue visits in one place.',
            ),
            icon: Icons.calendar_month_outlined,
            action: OutlinedButton.icon(
              key: const ValueKey('open-business-directory'),
              onPressed: () =>
                  openAppPage<void>(context, const BusinessDirectoryScreen()),
              icon: const Icon(Icons.storefront_outlined),
              label: Text(context.tr('دليل الأنشطة', 'Business directory')),
            ),
          ),
          BrowseChoices(
            id: 'visit-tab',
            options: BrowseOptions.visitTabs,
            selected: browser.tab,
            onSelected: browser.setTab,
          ),
          const SizedBox(height: Space.lg),
          BrowseSearch(
            id: 'visit-search',
            value: browser.query,
            label: context.tr('البحث في الزيارات', 'Search visits'),
            hint: context.tr(
              'اسم النشاط أو الرقم الضريبي',
              'Business or tax number',
            ),
            onChanged: browser.setQuery,
          ),
          const SizedBox(height: Space.lg),
          if (browser.tab == VisitListTab.today) ...[
            DateStrip(date: browser.date, onChanged: browser.setDate),
            const SizedBox(height: Space.lg),
          ],
          BrowseResultCount(
            action: VisitFilterButton(browser: browser),
            label: RecordCount.visits(context, visits.length),
            onReset: browser.isFiltered ? browser.reset : null,
          ),
          if (visits.isEmpty)
            BrowseEmpty(
              title: context.tr('لا توجد زيارات مطابقة', 'No matching visits'),
              description: context.tr(
                'غيّر البحث أو أعد ضبط التصفية للعودة إلى جدول العينة.',
                'Change your search or reset filters to return to the sample schedule.',
              ),
              icon: Icons.event_busy_outlined,
              action: context.tr('عرض جدول العينة', 'Show sample schedule'),
              onAction: browser.reset,
            ),
          for (final visit in visits)
            VisitScheduleCard(
              visit: visit,
              showDate: browser.tab != VisitListTab.today,
            ),
          const SizedBox(height: Space.md),
          FilledButton.icon(
            key: const ValueKey('filtered-route'),
            onPressed: visits.isEmpty
                ? null
                : () => showRouteSheet(context, visits),
            icon: const Icon(Icons.map_outlined),
            label: Text(
              context.tr('مسار النتائج على الخريطة', 'Map these visits'),
            ),
          ),
        ],
      );
    },
  );
}
