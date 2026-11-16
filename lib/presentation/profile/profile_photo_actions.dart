import 'package:flutter/material.dart';
import '../../app/profile_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../core/profile_style.dart';

Future<void> editProfilePhoto(BuildContext context) async {
  final controller = ProfileScope.of(context);
  final action = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    sheetAnimationStyle: ProfileTokens.animationStyle(context),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const ValueKey('choose-profile-photo'),
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(
                context.tr('اختيار صورة شخصية', 'Choose a profile photo'),
              ),
              subtitle: Text(
                context.tr(
                  'تُحفظ على هذا الجهاز فقط • حتى 512 KB',
                  'Stored on this device only • up to 512 KB',
                ),
              ),
              onTap: () => Navigator.pop(context, 'choose'),
            ),
            if (controller.settings.photo != null)
              ListTile(
                key: const ValueKey('remove-profile-photo'),
                leading: const Icon(Icons.person_remove_outlined),
                title: Text(context.tr('إزالة الصورة', 'Remove photo')),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
          ],
        ),
      ),
    ),
  );
  if (action == 'choose') await controller.choosePhoto();
  if (action == 'remove') {
    await controller.update(controller.settings.copyWith(removePhoto: true));
  }
}
