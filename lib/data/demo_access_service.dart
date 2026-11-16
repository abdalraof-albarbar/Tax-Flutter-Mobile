import '../domain/access.dart';

/// UI preview only: no account, email, token, network or credential store.
class DemoAccessService implements AccessPreviewService {
  @override
  Future<void> submit(AccessRequest request) async {}
}
