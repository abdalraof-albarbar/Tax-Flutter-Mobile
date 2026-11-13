import 'package:flutter/material.dart';
import '../../app/profile_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import 'inspector_avatar.dart';
import 'profile_page_route.dart';

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
          ProfilePageRoute(
            reduceMotion: MediaQuery.disableAnimationsOf(context),
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
