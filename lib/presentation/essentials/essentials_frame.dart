import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/profile_style.dart';
import '../../core/theme.dart';

class EssentialsFrame extends StatelessWidget {
  const EssentialsFrame({
    super.key,
    required this.title,
    required this.children,
  });
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Theme(
    data: ProfileTokens.theme(Theme.of(context)),
    child: Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Space.content),
            child: LayoutBuilder(
              builder: (context, constraints) => CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    leadingWidth: Space.touch + Space.sm,
                    titleSpacing: Space.lg,
                    toolbarHeight: ProfileTokens.toolbarHeight(
                      context,
                      title,
                      constraints.maxWidth,
                    ),
                    backgroundColor: Palette.white,
                    surfaceTintColor: ProfileTokens.clear,
                    scrolledUnderElevation: 0,
                    leading: IconButton(
                      key: const ValueKey('essentials-back'),
                      tooltip: context.tr('رجوع', 'Back'),
                      onPressed: () => Navigator.maybePop(context),
                      icon: const BackButtonIcon(),
                    ),
                    title: MediaQuery(
                      data: MediaQuery.of(context),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(Space.lg),
                    sliver: SliverList.list(
                      children: [
                        ...children,
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
    ),
  );
}
