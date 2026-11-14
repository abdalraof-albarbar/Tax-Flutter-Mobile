import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'surface.dart';

class BrowseEmpty extends StatelessWidget {
  const BrowseEmpty({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.action,
    this.onAction,
  });
  final String title, description;
  final IconData icon;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Surface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconTile(icon),
        const SizedBox(height: Space.lg),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: Space.sm),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Palette.muted),
        ),
        if (onAction != null && action != null) ...[
          const SizedBox(height: Space.lg),
          FilledButton(onPressed: onAction, child: Text(action!)),
        ],
      ],
    ),
  );
}
