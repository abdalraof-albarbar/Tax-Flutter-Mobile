import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';
import '../widgets/screen_frame.dart';
import '../widgets/surface.dart';
import '../widgets/visit_tile.dart';
import 'route_sheet.dart';
import 'visit_filters.dart';

class VisitsScreen extends StatefulWidget {
  const VisitsScreen({super.key});
  @override
  State<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  int tab = 0;
  String query = '', area = 'all', priority = 'all';
  DateTime date = SampleData.date;
  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final visits = controller.filtered(
      query: query,
      area: area,
      priority: priority,
      date: date,
      tab: tab,
    );
    return PageBody(
      children: [
        SegmentedButton<int>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(value: 0, label: Text(context.tr('اليوم', 'Today'))),
            ButtonSegment(
              value: 1,
              label: Text(context.tr('القادمة', 'Upcoming')),
            ),
            ButtonSegment(
              value: 2,
              label: Text(context.tr('المكتملة', 'Completed')),
            ),
          ],
          selected: {tab},
          onSelectionChanged: (values) => setState(() => tab = values.first),
        ),
        const SizedBox(height: Space.lg),
        if (tab == 0) ...[
          DateStrip(
            date: date,
            onChanged: (value) => setState(() => date = value),
          ),
          const SizedBox(height: Space.lg),
        ],
        TextField(
          key: const ValueKey('visit-search'),
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: context.tr(
              'ابحث باسم النشاط أو الرقم الضريبي',
              'Search business or tax number',
            ),
          ),
        ),
        const SizedBox(height: Space.md),
        VisitFilters(
          area: area,
          priority: priority,
          onArea: (value) => setState(() => area = value),
          onPriority: (value) => setState(() => priority = value),
        ),
        SectionTitle(
          context.tr('زيارات ${tab == 0 ? 'اليوم' : ''}', 'Visits'),
          action: Text('${visits.length} ${context.tr('زيارات', 'visits')}'),
        ),
        if (visits.isEmpty)
          Surface(
            child: Column(
              children: [
                const IconTile(Icons.event_busy_outlined),
                const SizedBox(height: Space.md),
                Text(context.tr('لا توجد زيارات مطابقة', 'No matching visits')),
                Text(
                  context.tr(
                    'جرّب تاريخًا أو تصفية أخرى',
                    'Try another date or filter',
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          )
        else
          Surface(
            child: Column(
              children: [
                for (var i = 0; i < visits.length; i++) ...[
                  if (i > 0) const Divider(),
                  VisitTile(visits[i]),
                ],
              ],
            ),
          ),
        const SizedBox(height: Space.lg),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton.icon(
            onPressed: visits.isEmpty
                ? null
                : () => showRouteSheet(context, visits),
            icon: const Icon(Icons.map_outlined),
            label: Text(context.tr('الخريطة', 'Map')),
          ),
        ),
      ],
    );
  }
}
