import 'package:flutter/material.dart';
import '../app/app_scope.dart';
import '../app/profile_scope.dart';
import '../core/localization.dart';
import '../core/theme.dart';
import 'home/home_screen.dart';
import 'reports/reports_screen.dart';
import 'visits/visits_screen.dart';
import 'widgets/surface.dart';
import 'profile/profile_launcher.dart';
import 'widgets/feedback.dart';

class InspectorShell extends StatefulWidget {
  const InspectorShell({
    super.key,
    required this.onToggleLanguage,
    required this.selectedIndex,
    required this.onSelected,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Future<bool> Function() onToggleLanguage;
  @override
  State<InspectorShell> createState() => _InspectorShellState();
}

class _InspectorShellState extends State<InspectorShell> {
  int get index => widget.selectedIndex;
  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final profile = ProfileScope.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 600;
    final labels = [
      context.tr('الرئيسية', 'Home'),
      context.tr('زياراتي', 'My visits'),
      context.tr('محاضري', 'My reports'),
    ];
    const icons = [
      Icons.home_outlined,
      Icons.calendar_month_outlined,
      Icons.assignment_outlined,
    ];
    final pages = [
      HomeScreen(onShowVisits: () => widget.onSelected(1)),
      const VisitsScreen(),
      const ReportsScreen(),
    ];
    final content = controller.loading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              if (controller.error == 'load')
                Padding(
                  padding: const EdgeInsets.all(Space.sm),
                  child: Notice(
                    context.tr(
                      'تعذر استعادة المسودات. أعد المحاولة قبل التعديل.',
                      'Could not restore drafts. Retry before editing.',
                    ),
                    warning: true,
                  ),
                ),
              if (controller.error == 'load')
                TextButton(
                  onPressed: controller.initialize,
                  child: Text(context.tr('إعادة المحاولة', 'Retry')),
                ),
              Expanded(
                child: IgnorePointer(
                  ignoring: controller.error == 'load',
                  child: AnimatedSwitcher(
                    duration: MotionTokens.duration(context),
                    child: KeyedSubtree(
                      key: ValueKey(index),
                      child: pages[index],
                    ),
                  ),
                ),
              ),
            ],
          );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Space.touch + Space.lg,
        title: ProfileLauncher(subtitle: index > 0 ? labels[index] : null),
        actions: [
          TextButton(
            key: const ValueKey('language'),
            onPressed: !profile.canEdit
                ? null
                : () async {
                    // A second tap can arrive before the disabled state is painted.
                    if (!profile.canEdit) return;
                    final saved = await widget.onToggleLanguage();
                    if (!saved && profile.error == 'save' && context.mounted) {
                      showMessage(
                        context,
                        'تعذر حفظ اللغة. حاول مجددًا.',
                        'Could not save language. Please retry.',
                      );
                    }
                  },
            child: Text(context.tr('EN', 'عربي')),
          ),
          IconButton(
            tooltip: context.tr('الإشعارات', 'Notifications'),
            icon: const Badge(
              smallSize: Space.sm,
              child: Icon(Icons.notifications_outlined),
            ),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(context.tr('الإشعارات', 'Notifications')),
                content: Text(
                  context.tr(
                    'لا توجد إشعارات جديدة في النسخة التجريبية.',
                    'No new notifications in this demo.',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.tr('حسنًا', 'OK')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (wide)
              NavigationRail(
                selectedIndex: index,
                labelType: NavigationRailLabelType.all,
                onDestinationSelected: widget.onSelected,
                destinations: [
                  for (var i = 0; i < labels.length; i++)
                    NavigationRailDestination(
                      icon: Icon(icons[i]),
                      label: Text(labels[i]),
                    ),
                ],
              ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Space.content),
                  child: content,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: index,
              onDestinationSelected: widget.onSelected,
              destinations: [
                for (var i = 0; i < labels.length; i++)
                  NavigationDestination(icon: Icon(icons[i]), label: labels[i]),
              ],
            ),
    );
  }
}
