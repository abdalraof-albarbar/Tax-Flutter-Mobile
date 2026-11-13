import 'package:flutter/widgets.dart';
import '../application/access_controller.dart';

class AccessScope extends InheritedNotifier<AccessController> {
  const AccessScope({
    super.key,
    required AccessController? controller,
    required super.child,
  }) : super(notifier: controller);
  static AccessController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AccessScope>()?.notifier;
  static AccessController of(BuildContext context) => maybeOf(context)!;
}
