import 'package:flutter/material.dart';
import '../../app/profile_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import 'inspector_avatar.dart';
import 'profile_screen.dart';

class ProfileLauncher extends StatelessWidget {
  const ProfileLauncher({super.key, this.subtitle});
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        key: const ValueKey('open-profile'),
        tooltip: context.tr('الملف الشخصي والإعدادات', 'Profile and settings'),
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.push(
          context,
          PageRouteBuilder<void>(
            transitionDuration: MotionTokens.duration(context),
            reverseTransitionDuration: MotionTokens.duration(context),
            pageBuilder: (_, _, _) => const ProfileScreen(),
            transitionsBuilder: (_, animation, _, child) => FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            ),
          ),
        ),
        icon: InspectorAvatar(
          photo: ProfileScope.of(context).settings.photo,
          hero: true,
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(width: Space.md),
        Flexible(
          child: Text(
            subtitle!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    ],
  );
}
