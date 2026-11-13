import 'package:flutter/material.dart';
import 'profile_style.dart';

class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({required Widget child, required bool reduceMotion})
    : super(
        transitionDuration: reduceMotion ? Duration.zero : ProfileTokens.enter,
        reverseTransitionDuration: reduceMotion
            ? Duration.zero
            : ProfileTokens.exit,
        pageBuilder: (_, _, _) => child,
      );
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    controller?.duration = reduced ? Duration.zero : ProfileTokens.enter;
    controller?.reverseDuration = reduced ? Duration.zero : ProfileTokens.exit;
    return reduced
        ? child
        : FadeTransition(
            opacity: animation.drive(CurveTween(curve: ProfileTokens.curve)),
            child: child,
          );
  }
}

Future<T?> openAppPage<T>(BuildContext context, Widget page) =>
    Navigator.push<T>(
      context,
      AppPageRoute<T>(
        child: page,
        reduceMotion: MediaQuery.disableAnimationsOf(context),
      ),
    );
