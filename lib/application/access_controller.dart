import 'package:flutter/foundation.dart';
import '../domain/access.dart';

class AccessController extends ChangeNotifier {
  AccessController({required this.service});
  final AccessPreviewService service;
  bool exploring = false, busy = false, failed = false;
  bool _disposed = false;
  Future<bool> submit(AccessRequest request) async {
    if (busy) return false;
    if (!AccessValidation.email(request.email) ||
        (request.intent != AccessIntent.recovery &&
            !AccessValidation.password(request.password)) ||
        (request.intent == AccessIntent.signup &&
            !AccessValidation.name(request.name))) {
      return false;
    }
    busy = true;
    failed = false;
    notifyListeners();
    try {
      await service.submit(request);
      return !_disposed;
    } catch (_) {
      if (!_disposed) failed = true;
      return false;
    } finally {
      if (!_disposed) {
        busy = false;
        notifyListeners();
      }
    }
  }

  void startDemo() {
    exploring = true;
    failed = false;
    notifyListeners();
  }

  void endDemo() {
    exploring = false;
    failed = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
