import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';

class ScreenFrame extends StatelessWidget {
  const ScreenFrame({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions,
    this.bottom,
    this.onBack,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget>? actions;
  final Widget? bottom;
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        key: const ValueKey('screen-back'),
        tooltip: context.tr('رجوع', 'Back'),
        onPressed: onBack ?? () => Navigator.maybePop(context),
        icon: const BackButtonIcon(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          if (subtitle != null)
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      toolbarHeight: Space.touch + Space.xxl,
      actions: actions,
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.content),
          child: child,
        ),
      ),
    ),
    bottomNavigationBar: bottom == null
        ? null
        : SafeArea(
            top: false,
            child: Container(
              color: Palette.white,
              padding: const EdgeInsets.all(Space.lg),
              child: Center(
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Space.content),
                  child: bottom!,
                ),
              ),
            ),
          ),
  );
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(Space.lg),
    children: [
      ...children,
      const SizedBox(height: Space.xl),
      Text(
        context.tr(
          'تصميم تجريبي • بيانات نموذجية',
          'Demo design • Sample data',
        ),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      const SizedBox(height: Space.xl),
    ],
  );
}
