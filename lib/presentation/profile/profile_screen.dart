import 'package:flutter/material.dart';
import '../../core/profile_style.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import 'profile_header.dart';
import 'profile_preferences.dart';
import 'profile_status.dart';
import 'profile_privacy.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Theme(
    data: ProfileTokens.theme(Theme.of(context)),
    child: Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Space.content),
            child: CustomScrollView(
              key: const ValueKey('profile-scroll'),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight:
                      ProfileTokens.headerHeight *
                      MediaQuery.textScalerOf(context).scale(1),
                  toolbarHeight: Space.touch + Space.lg,
                  backgroundColor: Palette.white,
                  surfaceTintColor: Colors.transparent,
                  foregroundColor: Palette.ink,
                  iconTheme: const IconThemeData(color: Palette.ink),
                  scrolledUnderElevation: 0,
                  leading: IconButton(
                    key: const ValueKey('profile-back'),
                    tooltip: context.tr('رجوع', 'Back'),
                    onPressed: () => Navigator.pop(context),
                    icon: const BackButtonIcon(),
                  ),
                  title: Text(
                    context.tr('الملف الشخصي', 'Your profile'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: MediaQuery.disableAnimationsOf(context)
                        ? CollapseMode.pin
                        : CollapseMode.parallax,
                    background: const ProfileHeader(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(Space.lg),
                  sliver: SliverList.list(
                    children: [
                      const ProfileStatus(),
                      const SizedBox(height: Space.xl),
                      Text(
                        context.tr('تفضيلاتك', 'Your preferences'),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        context.tr(
                          'اضبط التطبيق بما يناسبك',
                          'Set up the app to suit you',
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: Space.lg),
                      const ProfilePreferences(),
                      const SizedBox(height: Space.xl),
                      const ProfilePrivacy(),
                      const SizedBox(height: Space.xl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
