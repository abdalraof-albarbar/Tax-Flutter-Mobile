import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';

class DateStrip extends StatefulWidget {
  const DateStrip({super.key, required this.date, required this.onChanged});
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  @override
  State<DateStrip> createState() => _DateStripState();
}

class _DateStripState extends State<DateStrip> {
  final _scroll = ScrollController();
  final _dateKeys = List.generate(7, (_) => GlobalKey());
  final _firstDate = DateTime(SampleData.date.year);
  final _lastDate = DateTime(SampleData.date.year + 1, 12, 31);
  DateTime get _weekStart =>
      widget.date.subtract(Duration(days: widget.date.weekday % 7));

  @override
  void didUpdateWidget(DateStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (DateUtils.isSameDay(oldWidget.date, widget.date)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelectedDate());
  }

  void _revealSelectedDate() {
    if (!mounted || !_scroll.hasClients) return;
    final selected = _dateKeys[widget.date.weekday % 7].currentContext
        ?.findRenderObject();
    if (selected == null) return;
    // Scroll this strip only; the surrounding visits page keeps its position.
    _scroll.position.ensureVisible(
      selected,
      alignment: .5,
      duration: MotionTokens.duration(context),
      curve: Curves.easeOut,
    );
  }

  bool _canChangeWeek(int days) {
    final start = _weekStart.add(Duration(days: days));
    final end = start.add(const Duration(days: 6));
    return !end.isBefore(_firstDate) && !start.isAfter(_lastDate);
  }

  void _changeWeek(int days) {
    var next = widget.date.add(Duration(days: days));
    if (next.isBefore(_firstDate)) next = _firstDate;
    if (next.isAfter(_lastDate)) next = _lastDate;
    widget.onChanged(next);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                MaterialLocalizations.of(context).formatMonthYear(widget.date),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: context.tr('اختيار تاريخ', 'Choose date'),
              onPressed: () async {
                final value = await showDatePicker(
                  context: context,
                  initialDate: widget.date,
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                );
                if (value != null && mounted) widget.onChanged(value);
              },
              icon: const Icon(Icons.calendar_month_outlined),
            ),
          ],
        ),
        Wrap(
          spacing: Space.sm,
          runSpacing: Space.xs,
          children: [
            TextButton.icon(
              key: const ValueKey('previous-week'),
              onPressed: _canChangeWeek(-7) ? () => _changeWeek(-7) : null,
              icon: Icon(
                context.isArabic
                    ? Icons.chevron_right_rounded
                    : Icons.chevron_left_rounded,
              ),
              label: Text(context.tr('الأسبوع السابق', 'Previous week')),
            ),
            TextButton.icon(
              key: const ValueKey('next-week'),
              onPressed: _canChangeWeek(7) ? () => _changeWeek(7) : null,
              icon: Icon(
                context.isArabic
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
              ),
              label: Text(context.tr('الأسبوع التالي', 'Next week')),
            ),
          ],
        ),
        SizedBox(
          height: (Space.touch + Space.xxl) * textScale,
          child: SingleChildScrollView(
            key: const PageStorageKey('visit-date-strip'),
            controller: _scroll,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < 7; index++) ...[
                  if (index > 0) const SizedBox(width: Space.sm),
                  _buildDay(context, index),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDay(BuildContext context, int index) {
    final day = _weekStart.add(Duration(days: index));
    final available = !day.isBefore(_firstDate) && !day.isAfter(_lastDate);
    final selected = DateUtils.isSameDay(day, widget.date);
    final weekday = SampleData.weekdays[day.weekday - 1];
    final textColor = selected
        ? Palette.white
        : available
        ? Palette.ink
        : Palette.muted;
    return Semantics(
      key: _dateKeys[index],
      selected: selected,
      enabled: available,
      child: InkWell(
        onTap: available ? () => widget.onChanged(day) : null,
        borderRadius: BorderRadius.circular(Space.controlRadius),
        child: AnimatedContainer(
          duration: MotionTokens.duration(context),
          width:
              (Space.touch + Space.xxl) *
              MediaQuery.textScalerOf(context).scale(1),
          padding: const EdgeInsets.all(Space.sm),
          decoration: BoxDecoration(
            color: selected
                ? Palette.deepTeal
                : available
                ? Palette.white
                : Palette.background,
            border: Border.all(color: Palette.border),
            borderRadius: BorderRadius.circular(Space.controlRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.tr(weekday.arabic, weekday.english),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: textColor),
              ),
              Text(
                '${day.day}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
