import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../domain/inspection.dart';
import '../widgets/feedback.dart';
import '../widgets/surface.dart';

class AttachmentPanel extends StatelessWidget {
  const AttachmentPanel({
    super.key,
    required this.inspection,
    this.editable = true,
  });
  final Inspection inspection;
  final bool editable;
  Future<void> _pick(BuildContext context, {bool? camera}) async {
    final controller = AppScope.of(context);
    await controller.addAttachment(inspection, camera: camera);
    if (!context.mounted || controller.error == null) return;
    final message = switch (controller.error) {
      'size' => context.tr(
        'الحد الأقصى للملف 2 ميغابايت',
        'Maximum file size is 2 MB',
      ),
      'attachment_limit' => context.tr(
        'الحد الأقصى 6 مرفقات',
        'Maximum 6 attachments',
      ),
      _ => context.tr(
        'تعذر فتح الملف أو الوصول للكاميرا. جرّب المعرض.',
        'Could not access the file or camera. Try the gallery.',
      ),
    };
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final photos = inspection.attachments.where((a) => a.isImage).toList();
    final documents = inspection.attachments.where((a) => !a.isImage).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(context.tr('صور الزيارة', 'Visit photos')),
        Wrap(
          spacing: Space.md,
          runSpacing: Space.md,
          children: [
            for (final photo in photos)
              SizedBox(
                width: Space.preview,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => showDialog<void>(
                        context: context,
                        builder: (context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(Space.md),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Image.memory(
                                    photo.bytes,
                                    errorBuilder: (_, _, _) =>
                                        const Icon(Icons.broken_image_outlined),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(context.tr('إغلاق', 'Close')),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          Space.controlRadius,
                        ),
                        child: Image.memory(
                          photo.bytes,
                          width: Space.preview,
                          height: Space.preview,
                          fit: BoxFit.cover,
                          semanticLabel: photo.name,
                          errorBuilder: (_, _, _) =>
                              const IconTile(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                    if (editable)
                      IconButton(
                        tooltip: context.tr('حذف الصورة', 'Remove photo'),
                        onPressed: controller.busy
                            ? null
                            : () => controller.removeAttachment(
                                inspection,
                                photo.id,
                              ),
                        icon: const Icon(Icons.delete_outline),
                      ),
                  ],
                ),
              ),
            if (editable)
              SizedBox(
                width: Space.preview,
                height: Space.preview,
                child: OutlinedButton(
                  onPressed: controller.busy
                      ? null
                      : () => _pick(context, camera: true),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_outlined),
                      Text(
                        context.tr('التقاط صورة', 'Take photo'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        if (photos.isEmpty && !editable)
          Text(context.tr('لا توجد صور مرفقة', 'No photos attached')),
        if (editable)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: controller.busy
                  ? null
                  : () => _pick(context, camera: false),
              icon: const Icon(Icons.image_outlined),
              label: Text(
                context.tr('اختيار من المعرض', 'Choose from gallery'),
              ),
            ),
          ),
        const Divider(height: Space.xxl),
        SectionTitle(context.tr('المستندات', 'Documents')),
        for (final document in documents)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: Surface(
              padding: Space.sm,
              child: ListTile(
                leading: const IconTile(Icons.picture_as_pdf_outlined),
                title: Text(document.name),
                subtitle: Text(
                  '${(document.bytes.length / 1024).round()} KB • PDF',
                ),
                trailing: editable
                    ? IconButton(
                        tooltip: context.tr('حذف المستند', 'Remove document'),
                        onPressed: controller.busy
                            ? null
                            : () => controller.removeAttachment(
                                inspection,
                                document.id,
                              ),
                        icon: const Icon(Icons.delete_outline),
                      )
                    : null,
                onTap: () => showMessage(
                  context,
                  'تم إرفاق الملف. معاينة PDF داخل التطبيق غير متاحة بعد.',
                  'File attached. In-app PDF preview is not available yet.',
                ),
              ),
            ),
          ),
        if (documents.isEmpty && !editable)
          Text(context.tr('لا توجد مستندات مرفقة', 'No documents attached')),
        if (editable)
          OutlinedButton.icon(
            onPressed: controller.busy ? null : () => _pick(context),
            icon: const Icon(Icons.add),
            label: Text(context.tr('إضافة مستند PDF', 'Add PDF document')),
          ),
        if (editable)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.sm),
            child: Text(
              context.tr(
                'حتى 6 مرفقات، 2 ميغابايت لكل ملف. تُحفظ عند حفظ المسودة.',
                'Up to 6 attachments, 2 MB each. Stored when you save the draft.',
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        if (controller.busy) const LinearProgressIndicator(),
      ],
    );
  }
}
