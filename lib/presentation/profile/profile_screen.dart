import 'package:flutter/material.dart';
import '../../core/app_information.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import 'profile_header.dart';
import 'profile_preferences.dart';
import 'profile_status.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
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
                    Space.profileHeader *
                    MediaQuery.textScalerOf(context).scale(1),
                toolbarHeight: Space.touch + Space.lg,
                backgroundColor: Palette.deepTeal,
                surfaceTintColor: Colors.transparent,
                foregroundColor: Palette.white,
                iconTheme: const IconThemeData(color: Palette.white),
                leading: IconButton(
                  key: const ValueKey('profile-back'),
                  tooltip: context.tr('رجوع', 'Back'),
                  onPressed: () => Navigator.pop(context),
                  icon: const BackButtonIcon(),
                ),
                title: Text(
                  context.tr('الملف الشخصي', 'Your profile'),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Palette.white),
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
                      context.tr('على طريقتك', 'Make it yours'),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      context.tr(
                        'تفاصيل صغيرة ليوم عمل أسهل',
                        'Small details for a smoother day',
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: Space.lg),
                    const ProfilePreferences(),
                    const SizedBox(height: Space.xl),
                    PreferenceCard(
                      icon: Icons.privacy_tip_outlined,
                      title: context.tr(
                        'خصوصيتك على جهازك',
                        'Local to your device',
                      ),
                      subtitle: context.tr('بيئة تجريبية', 'Demo environment'),
                      child: Text(
                        context.tr(
                          'الصورة والتفضيلات محفوظة محليًا وغير مشفرة. لا تُرفع إلى خادم. '
                              'الاسم بيانات نموذجية؛ لا تحفظ بيانات حساسة في هذه النسخة.',
                          'Your photo and preferences stay locally, unencrypted. They are not '
                              'uploaded to a server. The name is sample data; avoid sensitive data in this demo.',
                        ),
                      ),
                    ),
                    const SizedBox(height: Space.xl),
                    Text(
                      context.tr(
                        'تفتيش • الإصدار ${AppInformation.version}',
                        'Inspection • Version ${AppInformation.version}',
                      ),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: Space.xl),
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
