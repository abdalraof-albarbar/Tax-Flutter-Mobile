import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../core/profile_style.dart';
import '../../domain/visit.dart';
import '../widgets/demo_map.dart';
import '../widgets/feedback.dart';

void showRouteSheet(BuildContext context, List<Visit> visits) {
  showModalBottomSheet<void>(
    context: context,
    sheetAnimationStyle: ProfileTokens.animationStyle(context),
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .75,
        child: ListView(
          padding: const EdgeInsets.all(Space.lg),
          children: [
            Text(
              context.tr('مسار الزيارات', 'Visit route'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: Space.lg),
            const DemoMap(route: true),
            const SizedBox(height: Space.md),
            Text(
              context.tr(
                'الرسم توضيحي. افتح الخرائط لاتجاهات كل زيارة.',
                'Illustrative map. Open Maps for directions to each visit.',
              ),
            ),
            for (final visit in visits)
              ListTile(
                title: Text(context.tr(visit.name, visit.englishName)),
                subtitle: Text(
                  '${visit.time} • ${context.tr(visit.area, visit.englishArea)}',
                ),
                trailing: const Icon(Icons.directions_outlined),
                onTap: () => openDirections(context, visit),
              ),
          ],
        ),
      ),
    ),
  );
}
