import 'package:flutter/material.dart';
import '../../core/browse_style.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';

class BrowseHeader extends StatelessWidget {
  const BrowseHeader({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.action,
  });
  final String title, description;
  final IconData icon;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: Space.xs),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Palette.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.md),
          ExcludeSemantics(
            child: Icon(
              icon,
              size: BrowseTokens.headerIcon,
              color: Palette.deepTeal,
            ),
          ),
        ],
      ),
      if (action != null) ...[const SizedBox(height: Space.md), action!],
      const SizedBox(height: Space.xl),
    ],
  );
}

class BrowseResultCount extends StatelessWidget {
  const BrowseResultCount({
    super.key,
    required this.label,
    this.onReset,
    this.action,
  });
  final String label;
  final VoidCallback? onReset;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Space.md),
    child: Wrap(
      spacing: Space.md,
      runSpacing: Space.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (action != null) action!,
        if (onReset != null)
          TextButton.icon(
            key: const ValueKey('reset-browse'),
            onPressed: onReset,
            icon: const Icon(Icons.restart_alt_rounded),
            label: Text(context.tr('إعادة الضبط', 'Reset filters')),
          ),
      ],
    ),
  );
}
