import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../application/inspection_controller.dart';
import '../core/theme.dart';
import '../presentation/shell.dart';
import 'app_scope.dart';
import 'navigation_scope.dart';

class InspectorApp extends StatefulWidget {
  const InspectorApp({super.key, required this.controller});
  final InspectionController controller;
  @override
  State<InspectorApp> createState() => _InspectorAppState();
}

class _InspectorAppState extends State<InspectorApp> {
  bool english = false;
  int selectedTab = 0;
  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
  }

  @override
  Widget build(BuildContext context) => AppScope(
    controller: widget.controller,
    child: NavigationScope(
      selectTab: (index) => setState(() => selectedTab = index),
      child: MaterialApp(
        title: 'تفتيش | Inspection',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        locale: Locale(english ? 'en' : 'ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: InspectorShell(
          selectedIndex: selectedTab,
          onSelected: (index) => setState(() => selectedTab = index),
          onToggleLanguage: () => setState(() => english = !english),
        ),
      ),
    ),
  );
}
