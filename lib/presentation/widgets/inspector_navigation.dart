import 'package:flutter/material.dart';
import '../../core/component_style.dart';
import '../../core/theme.dart';

class InspectorNavigation extends StatelessWidget {
  const InspectorNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.destinations,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<NavigationDestination> destinations;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    minimum: const EdgeInsets.all(Space.sm),
    child: DecoratedBox(
      decoration: ComponentTokens.navigation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ComponentTokens.cardRadius),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onSelected,
          destinations: destinations,
        ),
      ),
    ),
  );
}
