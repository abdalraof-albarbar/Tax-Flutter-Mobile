import 'package:flutter/material.dart';
import '../application/inspection_controller.dart';

class AppScope extends InheritedNotifier<InspectionController> {
  const AppScope({
    super.key,
    required InspectionController controller,
    required super.child,
  }) : super(notifier: controller);
  static InspectionController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
