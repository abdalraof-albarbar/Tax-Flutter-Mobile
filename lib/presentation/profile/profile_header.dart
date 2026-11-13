import 'package:flutter/material.dart';
import '../../app/profile_scope.dart';
import '../../core/localization.dart';
import '../../core/profile_style.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';
import 'profile_photo_actions.dart';
import 'profile_photo_button.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final profile = ProfileScope.of(context);
    return ColoredBox(
      color: Palette.background,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            Space.lg,
            Space.touch + Space.xxl,
            Space.lg,
            Space.xl,
          ),
          child: Container(
            decoration: ProfileTokens.identity,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                const PositionedDirectional(
                  start: 0,
                  top: 0,
                  bottom: 0,
                  width: ProfileTokens.accentRail,
                  child: ColoredBox(color: Palette.deepTeal),
                ),
                Padding(
                  padding: const EdgeInsets.all(Space.lg),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfilePhotoButton(
                        key: const ValueKey('edit-profile-photo'),
                        photo: profile.settings.photo,
                        onPressed: profile.canEdit
                            ? () => editProfilePhoto(context)
                            : null,
                      ),
                      const SizedBox(width: Space.lg),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              SampleData.inspector[context.isArabic ? 0 : 1],
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: Space.xs),
                            Text(
                              context.tr('مفتش ميداني', 'Field inspector'),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Palette.muted),
                            ),
                            const SizedBox(height: Space.md),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Space.sm,
                                vertical: Space.xs,
                              ),
                              decoration: BoxDecoration(
                                color: Palette.mint,
                                borderRadius: BorderRadius.circular(Space.sm),
                              ),
                              child: Text(
                                context.tr('حساب تجريبي', 'Demo account'),
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: Palette.deepTeal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
