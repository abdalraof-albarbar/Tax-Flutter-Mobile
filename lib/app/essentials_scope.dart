import 'package:flutter/widgets.dart';
import '../application/essentials_controller.dart';

class EssentialsScope extends InheritedNotifier<EssentialsController> {
  const EssentialsScope({
    super.key,
    required EssentialsController controller,
    required super.child,
  }) : super(notifier: controller);
  static EssentialsController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EssentialsScope>()!.notifier!;
}
