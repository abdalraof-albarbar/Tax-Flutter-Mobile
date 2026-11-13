import 'package:flutter/material.dart';

/// Navigation belongs to app composition, independently of inspection state.
class NavigationScope extends InheritedWidget {
  const NavigationScope({
    super.key,
    required this.selectTab,
    required super.child,
  });
  final ValueChanged<int> selectTab;
  static NavigationScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavigationScope>();
  @override
  bool updateShouldNotify(NavigationScope oldWidget) => false;
}
