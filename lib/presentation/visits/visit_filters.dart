import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../core/browse_style.dart';
import '../../data/sample_data.dart';
import '../../data/browse_options.dart';

export 'visit_date_strip.dart';

class VisitFilters extends StatelessWidget {
  const VisitFilters({
    super.key,
    required this.area,
    required this.priority,
    required this.onArea,
    required this.onPriority,
  });
  final String area, priority;
  final ValueChanged<String> onArea, onPriority;
  @override
  Widget build(BuildContext context) {
    final visits = AppScope.of(context).visits;
    final areas = {for (final visit in visits) visit.area: visit.englishArea};
    return LayoutBuilder(
      builder: (context, constraints) {
        final fields = [
          DropdownButtonFormField<String>(
            key: ValueKey('visit-area-$area'),
            initialValue: area,
            isExpanded: true,
            itemHeight: null,
            decoration: InputDecoration(
              labelText: context.tr('المنطقة', 'Area'),
            ),
            items: [
              for (final option in BrowseOptions.defaultAreas)
                DropdownMenuItem(
                  value: option.id,
                  child: Text(context.tr(option.arabic, option.english)),
                ),
              for (final entry in areas.entries)
                DropdownMenuItem(
                  value: entry.key,
                  child: Text(context.tr(entry.key, entry.value)),
                ),
            ],
            onChanged: (value) {
              if (value != null) onArea(value);
            },
          ),
          DropdownButtonFormField<String>(
            key: ValueKey('visit-priority-$priority'),
            initialValue: priority,
            isExpanded: true,
            itemHeight: null,
            decoration: InputDecoration(
              labelText: context.tr('الأولوية', 'Priority'),
            ),
            items: [
              for (final item in SampleData.priorities)
                DropdownMenuItem(
                  value: item.id,
                  child: Text(context.tr(item.arabic, item.english)),
                ),
            ],
            onChanged: (value) {
              if (value != null) onPriority(value);
            },
          ),
        ];
        return constraints.maxWidth < BrowseTokens.stackedWidth ||
                MediaQuery.textScalerOf(context).scale(1) >
                    BrowseTokens.largeText
            ? Column(
                children: [
                  fields[0],
                  const SizedBox(height: Space.md),
                  fields[1],
                ],
              )
            : Row(
                children: [
                  Expanded(child: fields[0]),
                  const SizedBox(width: Space.md),
                  Expanded(child: fields[1]),
                ],
              );
      },
    );
  }
}
