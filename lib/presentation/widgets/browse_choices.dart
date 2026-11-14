import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/browse_style.dart';
import '../../core/theme.dart';
import '../../domain/browse_choice.dart';

class BrowseChoices<T> extends StatelessWidget {
  const BrowseChoices({
    super.key,
    required this.id,
    required this.options,
    required this.selected,
    required this.onSelected,
  });
  final String id;
  final List<BrowseChoice<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;
  @override
  Widget build(BuildContext context) => KeyedSubtree(
    // Flutter 3.35 initializes RawChip controllers once; rebuild on motion changes.
    key: ValueKey(MediaQuery.disableAnimationsOf(context)),
    child: Wrap(
      spacing: Space.sm,
      runSpacing: Space.xs,
      children: [
        for (final choice in options)
          ChoiceChip(
            key: ValueKey('$id-${choice.value}'),
            label: Text(choice.label.text(context.isArabic)),
            selected: selected == choice.value,
            showCheckmark: true,
            chipAnimationStyle: BrowseTokens.chipMotion(context),
            selectedColor: Palette.mint,
            labelStyle: Theme.of(context).textTheme.labelLarge,
            padding: const EdgeInsets.symmetric(
              horizontal: Space.sm,
              vertical: Space.xs,
            ),
            onSelected: (_) => onSelected(choice.value),
          ),
      ],
    ),
  );
}
