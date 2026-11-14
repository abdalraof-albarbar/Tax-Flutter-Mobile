import 'package:flutter/material.dart';
import '../../application/visit_browser_controller.dart';
import '../../core/browse_style.dart';
import '../../core/localization.dart';
import '../../core/profile_style.dart';
import '../../core/theme.dart';
import '../../data/browse_options.dart';
import '../../domain/browse_choice.dart';
import 'visit_filters.dart';

class VisitFilterButton extends StatelessWidget {
  const VisitFilterButton({super.key, required this.browser});
  final VisitBrowserController browser;
  @override
  Widget build(BuildContext context) {
    final count = browser.activeFilterCount;
    final label = context.tr('تصفية وترتيب', 'Filter and sort');
    return OutlinedButton.icon(
      key: const ValueKey('open-visit-filters'),
      onPressed: () => showVisitFilters(context, browser),
      icon: const Icon(Icons.tune_rounded),
      label: Text(count == 0 ? label : '$label ($count)'),
    );
  }
}

Future<void> showVisitFilters(
  BuildContext context,
  VisitBrowserController browser,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  sheetAnimationStyle: ProfileTokens.animationStyle(context),
  builder: (_) => VisitFilterSheet(browser: browser),
);

class VisitFilterSheet extends StatefulWidget {
  const VisitFilterSheet({super.key, required this.browser});
  final VisitBrowserController browser;
  @override
  State<VisitFilterSheet> createState() => _VisitFilterSheetState();
}

class _VisitFilterSheetState extends State<VisitFilterSheet> {
  late String area = widget.browser.area, priority = widget.browser.priority;
  late VisitOrder order = widget.browser.order;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * BrowseTokens.sheetHeight,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr('تصفية وترتيب', 'Filter and sort'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  key: const ValueKey('cancel-visit-filters'),
                  tooltip: context.tr('إلغاء التغييرات', 'Cancel changes'),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            Text(
              context.tr(
                'اختر ما تحتاجه ثم طبّق التصفية.',
                'Choose what you need, then apply the filters.',
              ),
            ),
            const SizedBox(height: Space.xl),
            VisitFilters(
              area: area,
              priority: priority,
              onArea: (value) => setState(() => area = value),
              onPriority: (value) => setState(() => priority = value),
            ),
            const SizedBox(height: Space.lg),
            DropdownButtonFormField<VisitOrder>(
              key: ValueKey('visit-order-${order.name}'),
              initialValue: order,
              isExpanded: true,
              itemHeight: null,
              decoration: InputDecoration(
                labelText: context.tr('ترتيب الزيارات', 'Visit order'),
              ),
              items: [
                for (final choice in BrowseOptions.visitOrders)
                  DropdownMenuItem(
                    value: choice.value,
                    child: Text(choice.label.text(context.isArabic)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => order = value);
              },
            ),
            const SizedBox(height: Space.xl),
            FilledButton.icon(
              key: const ValueKey('apply-visit-filters'),
              onPressed: () {
                widget.browser.applyFilters(
                  area: area,
                  priority: priority,
                  order: order,
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_rounded),
              label: Text(context.tr('تطبيق التصفية', 'Apply filters')),
            ),
            const SizedBox(height: Space.sm),
            TextButton(
              key: const ValueKey('reset-visit-filter-draft'),
              onPressed: () => setState(() {
                area = 'all';
                priority = 'all';
                order = VisitOrder.schedule;
              }),
              child: Text(
                context.tr('مسح اختيارات التصفية', 'Clear filter choices'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
