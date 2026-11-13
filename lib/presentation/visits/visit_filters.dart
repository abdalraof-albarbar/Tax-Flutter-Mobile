import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';

class DateStrip extends StatelessWidget {
  const DateStrip({super.key, required this.date, required this.onChanged});
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final first = date.subtract(Duration(days: date.weekday % 7));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                MaterialLocalizations.of(context).formatMonthYear(date),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: context.tr('اختيار تاريخ', 'Choose date'),
              onPressed: () async {
                final value = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2027, 12, 31),
                );
                if (value != null) onChanged(value);
              },
              icon: const Icon(Icons.calendar_month_outlined),
            ),
          ],
        ),
        SizedBox(
          height: (Space.touch + Space.xxl) * textScale,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            separatorBuilder: (_, _) => const SizedBox(width: Space.sm),
            itemBuilder: (context, index) {
              final day = first.add(Duration(days: index));
              final selected =
                  day.day == date.day &&
                  day.month == date.month &&
                  day.year == date.year;
              final weekday = SampleData.weekdays[day.weekday - 1];
              return Semantics(
                selected: selected,
                child: InkWell(
                  onTap: () => onChanged(day),
                  borderRadius: BorderRadius.circular(Space.controlRadius),
                  child: AnimatedContainer(
                    duration: MotionTokens.duration(context),
                    width: (Space.touch + Space.xxl) * textScale,
                    padding: const EdgeInsets.all(Space.sm),
                    decoration: BoxDecoration(
                      color: selected ? Palette.teal : Palette.white,
                      border: Border.all(color: Palette.border),
                      borderRadius: BorderRadius.circular(Space.controlRadius),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.tr(weekday.arabic, weekday.english),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: selected ? Palette.white : Palette.ink,
                              ),
                        ),
                        Text(
                          '${day.day}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: selected ? Palette.white : Palette.ink,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

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
            initialValue: area,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: context.tr('المنطقة', 'Area'),
            ),
            items: [
              DropdownMenuItem(
                value: 'all',
                child: Text(context.tr('الكل', 'All')),
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
            initialValue: priority,
            isExpanded: true,
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
        return constraints.maxWidth < 350
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
