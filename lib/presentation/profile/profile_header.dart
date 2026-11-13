import 'package:flutter/material.dart';
import '../../app/profile_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';
import 'inspector_avatar.dart';
import 'profile_photo_actions.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final profile = ProfileScope.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Palette.deepTeal, Palette.teal],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.xl,
          Space.touch + Space.xl,
          Space.xl,
          Space.lg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InspectorAvatar(
              photo: profile.settings.photo,
              size: Space.profileAvatar,
              hero: true,
            ),
            const SizedBox(height: Space.sm),
            Text(
              SampleData.inspector[context.isArabic ? 0 : 1],
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Palette.white),
            ),
            Text(
              context.tr(
                'مفتش ميداني • حساب تجريبي',
                'Field inspector • Demo account',
              ),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Palette.white),
            ),
            const SizedBox(height: Space.md),
            OutlinedButton.icon(
              key: const ValueKey('edit-profile-photo'),
              onPressed:
                  profile.loading || profile.busy || profile.error == 'load'
                  ? null
                  : () => editProfilePhoto(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Palette.white,
                side: const BorderSide(color: Palette.white),
              ),
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(context.tr('تغيير الصورة', 'Change photo')),
            ),
          ],
        ),
      ),
    );
  }
}
