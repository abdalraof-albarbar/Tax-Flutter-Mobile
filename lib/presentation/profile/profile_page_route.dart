import 'package:flutter/material.dart';
import '../../core/profile_style.dart';
import 'profile_screen.dart';

class ProfilePageRoute extends PageRouteBuilder<void> {
  ProfilePageRoute({required bool reduceMotion})
    : super(
        transitionDuration: reduceMotion ? Duration.zero : ProfileTokens.enter,
        reverseTransitionDuration: reduceMotion
            ? Duration.zero
            : ProfileTokens.exit,
        pageBuilder: (_, _, _) => const ProfileScreen(),
      );
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final routeController = controller;
    if (routeController != null) {
      routeController.duration = reduced ? Duration.zero : ProfileTokens.enter;
      routeController.reverseDuration = reduced
          ? Duration.zero
          : ProfileTokens.exit;
    }
    if (reduced) return child;
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: ProfileTokens.curve)),
      child: child,
    );
  }
}
