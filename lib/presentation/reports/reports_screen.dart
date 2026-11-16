import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/navigation_scope.dart';
import '../../application/report_browser_controller.dart';
import '../../core/localization.dart';
import '../../core/record_count.dart';
import '../../core/theme.dart';
import '../../data/browse_options.dart';
import '../widgets/browse_choices.dart';
import '../widgets/browse_empty.dart';
import '../widgets/browse_header.dart';
import '../widgets/browse_search.dart';
import '../widgets/screen_frame.dart';
import 'report_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key, this.browser});
  final ReportBrowserController? browser;
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late final browser = widget.browser ?? ReportBrowserController();
  @override
  void dispose() {
    if (widget.browser == null) browser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: browser,
    builder: (context, _) {
      final controller = AppScope.of(context);
      final reports = browser.results(controller);
      final drafts = controller.reports.where((r) => !r.submitted).length;
      return PageBody(
        storageKey: 'reports',
        children: [
          BrowseHeader(
            title: context.tr('محاضري', 'My reports'),
            description: context.tr(
              'المسودات: $drafts • المرفوعة تجريبيًا: ${controller.reports.length - drafts}',
              'Drafts: $drafts • Demo submitted: ${controller.reports.length - drafts}',
            ),
            icon: Icons.assignment_outlined,
          ),
          BrowseSearch(
            id: 'report-search',
            value: browser.query,
            label: context.tr('البحث في المحاضر', 'Search reports'),
            hint: context.tr(
              'اسم النشاط أو رقم المحضر',
              'Business or report number',
            ),
            onChanged: browser.setQuery,
          ),
          const SizedBox(height: Space.lg),
          BrowseChoices(
            id: 'report-filter',
            options: BrowseOptions.reportFilters,
            selected: browser.filter,
            onSelected: browser.setFilter,
          ),
          BrowseResultCount(
            label: RecordCount.reports(context, reports.length),
            onReset: browser.isFiltered ? browser.reset : null,
          ),
          if (reports.isEmpty)
            BrowseEmpty(
              title: controller.reports.isEmpty
                  ? context.tr('لا توجد محاضر بعد', 'No reports yet')
                  : context.tr('لا توجد محاضر مطابقة', 'No matching reports'),
              description: controller.reports.isEmpty
                  ? context.tr(
                      'ابدأ زيارة لإنشاء أول مسودة. ستظهر هنا لمتابعتها.',
                      'Start a visit to create your first draft, then continue it here.',
                    )
                  : context.tr(
                      'غيّر البحث أو التصفية لإظهار محاضرك المحلية.',
                      'Change your search or filter to find your local reports.',
                    ),
              icon: Icons.description_outlined,
              action: browser.isFiltered
                  ? context.tr('عرض كل المحاضر', 'Show all reports')
                  : context.tr('استعرض الزيارات', 'Browse visits'),
              onAction: browser.isFiltered
                  ? browser.reset
                  : NavigationScope.maybeOf(context) == null
                  ? null
                  : () => NavigationScope.maybeOf(context)?.selectTab(1),
            ),
          for (final inspection in reports) ReportCard(inspection: inspection),
        ],
      );
    },
  );
}
