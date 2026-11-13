import 'package:flutter/material.dart';
import '../../core/theme.dart';

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.color = Palette.white,
    this.padding = Space.lg,
  });
  final Widget child;
  final Color color;
  final double padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(Space.radius),
      border: Border.all(color: Palette.border),
    ),
    child: child,
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action});
  final String title;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Space.md),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        if (action != null) action!,
      ],
    ),
  );
}

class IconTile extends StatelessWidget {
  const IconTile(this.icon, {super.key});
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    width: Space.touch,
    height: Space.touch,
    decoration: BoxDecoration(
      color: Palette.mint,
      borderRadius: BorderRadius.circular(Space.controlRadius),
    ),
    child: Icon(icon, color: Palette.deepTeal),
  );
}

class Notice extends StatelessWidget {
  const Notice(this.message, {super.key, this.warning = false});
  final String message;
  final bool warning;
  @override
  Widget build(BuildContext context) => Surface(
    color: warning ? Palette.amberLight : Palette.mint,
    padding: Space.md,
    child: Row(
      children: [
        Icon(
          Icons.info_outline,
          color: warning ? Palette.amber : Palette.deepTeal,
        ),
        const SizedBox(width: Space.sm),
        Expanded(
          child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    ),
  );
}
