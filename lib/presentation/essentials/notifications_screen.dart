import 'package:flutter/material.dart';
import '../../app/essentials_scope.dart';
import '../../core/localization.dart';
import '../../core/profile_style.dart';
import '../../core/theme.dart';
import 'essentials_frame.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool unreadOnly = false;
  @override
  Widget build(BuildContext context) {
    final controller = EssentialsScope.of(context);
    final notifications = controller.notifications
        .where((item) => !unreadOnly || !controller.isRead(item.id))
        .toList();
    return EssentialsFrame(
      title: context.tr('الإشعارات', 'Notifications'),
      children: [
        Text(
          context.tr('خليك على اطلاع', 'Stay in the loop'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          context.tr(
            'تذكيرات نموذجية فقط؛ لا توجد إشعارات دفع.',
            'Sample reminders only; push notifications are not connected.',
          ),
        ),
        const SizedBox(height: Space.lg),
        Text(
          context.tr(
            '${controller.unreadCount} غير مقروءة',
            '${controller.unreadCount} unread',
          ),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CheckboxListTile(
          key: const ValueKey('notifications-unread'),
          contentPadding: EdgeInsets.zero,
          value: unreadOnly,
          title: Text(context.tr('غير المقروءة فقط', 'Unread only')),
          onChanged: (value) => setState(() => unreadOnly = value ?? false),
        ),
        TextButton(
          key: const ValueKey('notifications-read-all'),
          onPressed: controller.unreadCount == 0
              ? null
              : controller.markAllRead,
          child: Text(context.tr('تمييز الكل كمقروء', 'Mark all as read')),
        ),
        const SizedBox(height: Space.lg),
        if (notifications.isEmpty)
          Container(
            decoration: ProfileTokens.panel,
            padding: const EdgeInsets.all(Space.xl),
            child: Column(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: Space.touch,
                  color: Palette.deepTeal,
                ),
                Text(
                  context.tr('كل شيء مقروء', 'You are all caught up'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  key: const ValueKey('notifications-show-all'),
                  onPressed: () => setState(() => unreadOnly = false),
                  child: Text(
                    context.tr('عرض كل الإشعارات', 'Show all notifications'),
                  ),
                ),
              ],
            ),
          ),
        for (final item in notifications)
          Container(
            margin: const EdgeInsets.only(bottom: Space.lg),
            padding: const EdgeInsets.all(Space.lg),
            decoration: ProfileTokens.panel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title.text(context.isArabic),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: Space.sm),
                Text(item.description.text(context.isArabic)),
                const SizedBox(height: Space.md),
                if (controller.isRead(item.id))
                  Text(
                    context.tr('مقروء', 'Read'),
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                else
                  TextButton(
                    key: ValueKey('notification-read-${item.id}'),
                    onPressed: () => controller.markRead(item.id),
                    child: Text(context.tr('تمييز كمقروء', 'Mark as read')),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
