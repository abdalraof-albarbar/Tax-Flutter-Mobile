import 'package:flutter/foundation.dart';
import '../domain/essential_content.dart';

class EssentialsController extends ChangeNotifier {
  EssentialsController({required List<DemoNotification> notifications})
    : notifications = List.unmodifiable(notifications);
  final List<DemoNotification> notifications;
  final Set<String> _read = {};
  bool isRead(String id) => _read.contains(id);
  int get unreadCount => notifications.where((n) => !isRead(n.id)).length;
  void markRead(String id) {
    if (notifications.any((n) => n.id == id) && _read.add(id)) {
      notifyListeners();
    }
  }

  void markAllRead() {
    if (unreadCount == 0) return;
    _read.addAll(notifications.map((n) => n.id));
    notifyListeners();
  }
}
