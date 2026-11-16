import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../application/inspection_controller.dart';
import '../application/visit_browser_controller.dart';
import '../application/report_browser_controller.dart';
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
  late final visitBrowser = VisitBrowserController(
    scheduleDate: widget.controller.scheduleDate,
  );
  late final reportBrowser = ReportBrowserController();
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
    if (!mounted) return;
    setState(() {
      if (widget.accessController?.exploring ?? false) return;
      selectedTab = 0;
      visitBrowser.reset();
      reportBrowser.reset();
    });
  }

  void _selectTab(int index) => setState(() => selectedTab = index);

  Future<bool> _toggleLanguage() => profile.update(
    profile.settings.copyWith(
      language: profile.settings.language == 'ar' ? 'en' : 'ar',
    ),
  );

  Widget _applyPreferences(BuildContext context, Widget? child) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        textScaler: PreferenceTextScaler(
          media.textScaler,
          profile.settings.textScale,
        ),
        disableAnimations:
            media.disableAnimations || profile.settings.reduceMotion,
      ),
      child: child!,
    );
  }

  Widget _buildHome() {
    final access = widget.accessController;
    if (access != null && !access.exploring) return const WelcomeScreen();
    return InspectorShell(
      visitBrowser: visitBrowser,
      reportBrowser: reportBrowser,
      selectedIndex: selectedTab,
      onSelected: _selectTab,
      onToggleLanguage: _toggleLanguage,
    );
  }

  Widget _buildMaterialApp() {
    return MaterialApp(
      title: 'تفتيش | Inspection',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      locale: Locale(profile.settings.language),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: _applyPreferences,
      home: _buildHome(),
    );
  }

  @override
  void dispose() {
    visitBrowser.dispose();
    reportBrowser.dispose();
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
            selectTab: _selectTab,
            child: _buildMaterialApp(),
          ),
        ),
      ),
    ),
  );
}
