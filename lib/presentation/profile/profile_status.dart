import 'package:flutter/material.dart';
import '../../app/profile_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../widgets/surface.dart';

class ProfileStatus extends StatelessWidget {
  const ProfileStatus({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = ProfileScope.of(context);
    final error = controller.error;
    final messages = <String, String>{
      'load': context.tr(
        'تعذر استعادة الإعدادات. أعد المحاولة قبل التعديل.',
        'Could not restore settings. Retry before editing.',
      ),
      'save': context.tr(
        'تعذر حفظ التغيير. بقيت إعداداتك السابقة؛ حاول مجددًا.',
        'Could not save this change. Your previous settings are kept; please retry.',
      ),
      'photo_size': context.tr(
        'اختر صورة أصغر من 512 KB.',
        'Please choose a photo smaller than 512 KB.',
      ),
      'picker': context.tr(
        'تعذر فتح الصورة. تحقق من صلاحية الوصول وحاول مجددًا.',
        'Could not open the photo. Check access and try again.',
      ),
    };
    if (error != null) {
      return Column(
        children: [
          Semantics(
            liveRegion: true,
            child: Notice(messages[error] ?? messages['save']!, warning: true),
          ),
          if (error == 'load')
            TextButton.icon(
              onPressed: controller.loading ? null : controller.initialize,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.tr('إعادة المحاولة', 'Retry')),
            ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          controller.busy || controller.loading
              ? Icons.sync_rounded
              : Icons.check_circle_outline_rounded,
          color: Palette.teal,
          size: Space.lg,
        ),
        const SizedBox(width: Space.sm),
        Flexible(
          child: Text(
            controller.loading
                ? context.tr('استعادة إعداداتك…', 'Restoring your settings…')
                : controller.busy
                ? context.tr('جارٍ الحفظ…', 'Saving…')
                : context.tr(
                    'تُحفظ التغييرات تلقائيًا على جهازك',
                    'Changes save automatically on this device',
                  ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
