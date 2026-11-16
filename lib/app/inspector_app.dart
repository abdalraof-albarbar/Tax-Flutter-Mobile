import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../application/inspection_controller.dart';
import '../core/theme.dart';
import '../presentation/shell.dart';
import 'app_scope.dart';
import 'navigation_scope.dart';
import 'profile_scope.dart';
import '../application/profile_controller.dart';
import '../data/profile_services.dart';
import '../core/preference_text_scaler.dart';
import '../application/access_controller.dart';
import '../application/essentials_controller.dart';
import '../data/essential_samples.dart';
import '../presentation/access/welcome_screen.dart';
import 'access_scope.dart';
import 'essentials_scope.dart';

class InspectorApp extends StatefulWidget {
  const InspectorApp({
    super.key,
    required this.controller,
    this.profileController,
    this.accessController,
    this.essentialsController,
  });
  final InspectionController controller;
  final ProfileController? profileController;
  final AccessController? accessController;
  final EssentialsController? essentialsController;
  @override
  State<InspectorApp> createState() => _InspectorAppState();
}

class _InspectorAppState extends State<InspectorApp> {
  late final ProfileController profile;
  late final EssentialsController essentials;
  int selectedTab = 0;
  @override
  void initState() {
    super.initState();
    profile =
        widget.profileController ??
        ProfileController(
          store: SessionProfileStore(),
          photoPicker: UnavailableProfilePhotoPicker(),
        );
    profile.addListener(_profileChanged);
    essentials =
        widget.essentialsController ??
        EssentialsController(notifications: EssentialSamples.notifications);
    widget.accessController?.addListener(_accessChanged);
    profile.initialize();
    widget.controller.initialize();
  }

  void _profileChanged() {
    if (mounted) setState(() {});
  }

  void _accessChanged() {
    if (mounted) {
      setState(() {
        if (!(widget.accessController?.exploring ?? false)) selectedTab = 0;
      });
    }
  }

  @override
  void dispose() {
    profile.removeListener(_profileChanged);
    widget.accessController?.removeListener(_accessChanged);
    if (widget.essentialsController == null) essentials.dispose();
    if (widget.profileController == null) profile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppScope(
    controller: widget.controller,
    child: ProfileScope(
      controller: profile,
      child: AccessScope(
        controller: widget.accessController,
        child: EssentialsScope(
          controller: essentials,
          child: NavigationScope(
            selectTab: (index) => setState(() => selectedTab = index),
            child: MaterialApp(
              title: 'تفتيش | Inspection',
              debugShowCheckedModeBanner: false,
              theme: buildTheme(),
              locale: Locale(profile.settings.language),
              supportedLocales: const [Locale('ar'), Locale('en')],
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              builder: (context, child) {
                final media = MediaQuery.of(context);
                return MediaQuery(
                  data: media.copyWith(
                    textScaler: PreferenceTextScaler(
                      media.textScaler,
                      profile.settings.textScale,
                    ),
                    disableAnimations:
                        media.disableAnimations ||
                        profile.settings.reduceMotion,
                  ),
                  child: child!,
                );
              },
              home:
                  widget.accessController != null &&
                      !widget.accessController!.exploring
                  ? const WelcomeScreen()
                  : InspectorShell(
                      selectedIndex: selectedTab,
                      onSelected: (index) =>
                          setState(() => selectedTab = index),
                      onToggleLanguage: () => profile.update(
                        profile.settings.copyWith(
                          language: profile.settings.language == 'ar'
                              ? 'en'
                              : 'ar',
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    ),
  );
}
