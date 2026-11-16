import 'package:tax_inspector_mobile/domain/access.dart';

class FakeAccessService implements AccessPreviewService {
  int calls = 0;
  bool fail = false;
  Future<void> Function()? completion;
  @override
  Future<void> submit(AccessRequest request) async {
    calls++;
    if (fail) throw StateError('simulated unavailable preview');
    await completion?.call();
  }
}
