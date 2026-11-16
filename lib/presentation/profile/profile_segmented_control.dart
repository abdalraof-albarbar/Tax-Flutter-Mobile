import 'package:flutter/material.dart';
import '../../core/profile_style.dart';
import '../../core/theme.dart';

class ProfileSegment<T> {
  const ProfileSegment({required this.value, required this.label});
  final T value;
  final String label;
}

class ProfileSegmentedControl<T> extends StatelessWidget {
  const ProfileSegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.keyPrefix,
    this.onSelected,
  });
  final List<ProfileSegment<T>> options;
  final T selected;
  final String keyPrefix;
  final ValueChanged<T>? onSelected;
  @override
  Widget build(BuildContext context) {
    final index = options.indexWhere((option) => option.value == selected);
    final position = options.length < 2
        ? 0.0
        : -1 + 2 * index / (options.length - 1);
    return DecoratedBox(
      decoration: ProfileTokens.track,
      child: Padding(
        padding: const EdgeInsets.all(Space.xs),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedAlign(
                key: ValueKey(Directionality.of(context)),
                duration: ProfileTokens.duration(context),
                curve: ProfileTokens.curve,
                alignment: AlignmentDirectional(position, 0),
                child: FractionallySizedBox(
                  widthFactor: 1 / options.length,
                  heightFactor: 1,
                  child: DecoratedBox(decoration: ProfileTokens.selection),
                ),
              ),
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final option in options)
                    Expanded(
                      child: _ProfileOption(
                        key: ValueKey('$keyPrefix-${option.value}'),
                        label: option.label,
                        selected: option.value == selected,
                        onPressed: onSelected == null
                            ? null
                            : () => onSelected!(option.value),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption extends StatefulWidget {
  const _ProfileOption({
    super.key,
    required this.label,
    required this.selected,
    this.onPressed,
  });
  final String label;
  final bool selected;
  final VoidCallback? onPressed;
  @override
  State<_ProfileOption> createState() => _ProfileOptionState();
}

class _ProfileOptionState extends State<_ProfileOption> {
  bool focused = false;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: widget.selected,
    enabled: widget.onPressed != null,
    focusable: widget.onPressed != null,
    focused: focused,
    label: widget.label,
    onTap: widget.onPressed,
    excludeSemantics: true,
    child: AnimatedContainer(
      duration: ProfileTokens.duration(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Space.controlRadius),
        border: Border.all(
          width: ProfileTokens.focusWidth,
          color: focused ? Palette.deepTeal : ProfileTokens.clear,
        ),
      ),
      child: Material(
        color: ProfileTokens.clear,
        child: InkWell(
          onTap: widget.onPressed,
          excludeFromSemantics: true,
          onFocusChange: (value) => setState(() => focused = value),
          borderRadius: BorderRadius.circular(Space.controlRadius),
          splashColor: ProfileTokens.splash,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: ProfileTokens.controlHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Space.sm,
                vertical: Space.md,
              ),
              child: Center(
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: widget.onPressed == null
                        ? Palette.muted
                        : Palette.ink,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
